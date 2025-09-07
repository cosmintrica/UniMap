import SwiftUI
import UniformTypeIdentifiers

// Doc pt export
struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data
    init(data: Data = Data()) { self.data = data }
    init(configuration: ReadConfiguration) throws { data = configuration.file.regularFileContents ?? Data() }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { .init(regularFileWithContents: data) }
}

enum DraftTool: String, CaseIterable { case room = "Cameră", corridor = "Hol", node = "Nod", edge = "Muchie" }

struct MapEditorView: View {
    @State private var tool: DraftTool = .room
    @State private var points: [CGPoint] = []
    @State private var rooms: [RoomPolygon] = []
    @State private var corridors: [[CGPoint]] = []
    @State private var nodes: [Node] = []
    @State private var edges: [Edge] = []
    @State private var currentName = ""
    @State private var selectedNodeID: String?

    @State private var bgImage: UIImage?
    @State private var showImageImporter = false
    @State private var showExporter = false
    @State private var exportDoc = JSONDocument()

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // fundal screenshot
                    if let img = bgImage {
                        Image(uiImage: img).resizable().scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .opacity(0.55)
                    }

                    // desen existent
                    ForEach(rooms) { r in IndoorPolygon(points: r.points).stroke(.blue, lineWidth: 1) }
                    ForEach(corridors.indices, id: \.self) { i in IndoorPolygon(points: corridors[i]).stroke(.orange, lineWidth: 1) }
                    ForEach(nodes) { n in
                        Circle().fill(.green).frame(width: 10, height: 10)
                            .position(n.point.indoorScaled(to: geo.size))
                    }

                    // desen curent
                    Path { p in
                        let s = points.map { $0.indoorScaled(to: geo.size) }
                        if let first = s.first {
                            p.move(to: first)
                            for pt in s.dropFirst() { p.addLine(to: pt) }
                        }
                    }
                    .stroke(.red, style: .init(lineWidth: 2, dash: [4,4]))
                }
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0).onEnded { v in
                    let m = CGPoint(x: v.location.x / geo.size.width, y: v.location.y / geo.size.height)
                    switch tool {
                    case .room, .corridor:
                        points.append(m)
                    case .node:
                        let id = "n\(nodes.count+1)"
                        nodes.append(.init(id: id, floor: 0, point: m, kind: .hallway))
                    case .edge:
                        if let sel = selectedNodeID,
                           let last = nodes.first(where: { $0.id == sel }),
                           let hit = nodes.min(by: { $0.point.distance(to: m) < $1.point.distance(to: m) }) {
                            edges.append(.init(from: last.id, to: hit.id, weight: Double(last.point.distance(to: hit.point))))
                            selectedNodeID = nil
                        } else if let hit = nodes.min(by: { $0.point.distance(to: m) < $1.point.distance(to: m) }) {
                            selectedNodeID = hit.id
                        }
                    }
                })
            }
            .navigationTitle("Editor hartă")
            .toolbar {
                // Top bar
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        showImageImporter = true
                    } label: { Label("Fundal", systemImage: "photo") }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        do { exportDoc = JSONDocument(data: try exportDraftData()); showExporter = true }
                        catch { print("Export error:", error) }
                    } label: { Label("Export", systemImage: "square.and.arrow.up") }
                }

                // Bottom bar – aranjat
                ToolbarItemGroup(placement: .bottomBar) {
                    Picker("", selection: $tool) {
                        ForEach(DraftTool.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    if tool == .room {
                        TextField("Nume cameră", text: $currentName)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 180)
                    }

                    Button("Închide poligon") {
                        guard points.count >= 3 else { return }
                        if tool == .room {
                            let id = currentName.isEmpty ? "R\(rooms.count+1)" : currentName
                            rooms.append(.init(id: id, name: id, floor: 0, points: points, info: nil))
                            currentName = ""
                        } else if tool == .corridor {
                            corridors.append(points)
                        }
                        points.removeAll()
                    }

                    Spacer()

                    Button("Șterge desen") {
                        points.removeAll()
                    }
                }
            }
            .fileImporter(isPresented: $showImageImporter, allowedContentTypes: [.image]) { res in
                if case .success(let url) = res,
                   let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data) {
                    bgImage = img
                }
            }
            .fileExporter(isPresented: $showExporter, document: exportDoc, contentType: .json, defaultFilename: "ucv_parter.json") { _ in }
        }
    }

    // Export simplu (DTO propriu – fără să cerem Codable pe Node/Edge)
    private func exportDraftData() throws -> Data {
        struct PT: Codable { let x: CGFloat; let y: CGFloat }
        struct RoomDTO: Codable { let id: String; let name: String; let floor: Int; let points: [PT]; let info: String? }
        struct NodeDTO: Codable { let id: String; let floor: Int; let x: CGFloat; let y: CGFloat; let kind: String }
        struct EdgeDTO: Codable { let from: String; let to: String; let weight: Double }
        struct FileDTO: Codable {
            let rooms: [RoomDTO]
            let corridors: [[PT]]
            let nodes: [NodeDTO]
            let edges: [EdgeDTO]
        }

        let r = rooms.map { RoomDTO(id: $0.id, name: $0.name, floor: $0.floor,
                                    points: $0.points.map { PT(x: $0.x, y: $0.y) }, info: $0.info) }
        let c = corridors.map { $0.map { PT(x: $0.x, y: $0.y) } }
        // în MapEditorView.swift, în func exportDraftData()
        let n: [NodeDTO] = nodes.map { node in
            let kindString: String
            switch node.kind {
            case .hallway:                    kindString = "hallway"
            case .room(let rid):              kindString = "room:\(rid)"
            case .stairs(let label):          kindString = "stairs:\(label)"
            case .entrance(let label):        kindString = "entrance:\(label)"
            case .elevator(let label):        kindString = "elevator:\(label)"
            }
            return NodeDTO(
                id: node.id,
                floor: node.floor,
                x: node.point.x,
                y: node.point.y,
                kind: kindString
            )
        }
        let e = edges.map { EdgeDTO(from: $0.from, to: $0.to, weight: $0.weight) }

        let dto = FileDTO(rooms: r, corridors: c, nodes: n, edges: e)
        let enc = JSONEncoder(); enc.outputFormatting = [.prettyPrinted]
        return try enc.encode(dto)
    }
}
