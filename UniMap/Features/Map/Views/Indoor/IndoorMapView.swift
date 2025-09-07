//
//  IndoorMapView.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import SwiftUI

struct IndoorMapView: View {
    let building: Building

    @Binding var currentFloorIndex: Int
    @Binding var startNode: String?
    @Binding var destNode: String?
    @Binding var pathNodeIDs: [String]
    var onExitRequested: () -> Void = {}

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    @State private var callout: (room: RoomPolygon, pt: CGPoint)?
    @State private var showRoomSheet: RoomPolygon?
    @State private var routeStage: RouteStage = .start
    @State private var floorsExpanded = false

    private enum RouteStage { case start, dest }

    var body: some View {
        GeometryReader { geo in
            let floor = building.floors[currentFloorIndex]
            let size = geo.size

            ZStack {
                Color(.systemBackground)

                CorridorsLayer(floor: floor, building: building, canvasSize: size)

                RoomsLayer(floor: floor, building: building, canvasSize: size) { room, center, nid in
                    callout = (room, center)
                    showRoomSheet = nil
                    if let nid { handleRoomTap(nid) }
                }
                .opacity(max(0, min(1, (scale - 0.7) / 0.3)))

                StairsLayer(floor: floor, canvasSize: size)
                GraphEdgesLayer(floor: floor, building: building, canvasSize: size)
                RouteLayer(floor: floor, building: building, canvasSize: size, pathNodeIDs: pathNodeIDs)

                NodesLayer(
                    floor: floor,
                    canvasSize: size,
                    startNode: startNode,
                    destNode: destNode,
                    onRoomNodeTapped: { handleRoomTap($0) }
                )

                MarkersLayer(floor: floor, building: building, canvasSize: size,
                             startNode: startNode, destNode: destNode)

                calloutLayer()
            }
            .scaleEffect(scale, anchor: .center)
            .offset(offset)
            .gesture(dragGesture)
            .gesture(pinchGesture)
        }
        .onAppear { resetTransform() }
        .sheet(item: $showRoomSheet, content: sheetContent(room:))
    }

    @ViewBuilder
    private func calloutLayer() -> some View {
        if let c = callout {
            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .onTapGesture { showRoomSheet = c.room }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(c.room.name).font(.footnote.bold())
                        if let info = c.room.info, !info.isEmpty {
                            Text(info).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
                .shadow(radius: 5)
                Spacer().frame(height: 90)
            }
            .position(c.pt)
            .zIndex(7)
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { v in
                offset = .init(width: lastOffset.width + v.translation.width,
                               height: lastOffset.height + v.translation.height)
            }
            .onEnded { _ in lastOffset = offset }
    }

    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 0.6), 3.0)
            }
            .onEnded { _ in
                lastScale = scale
                if scale <= 0.7 { onExitRequested() }
            }
    }

    private func sheetContent(room: RoomPolygon) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(room.name).font(.title3.bold())
            if let info = room.info, !info.isEmpty {
                Text(info).foregroundStyle(.secondary)
            } else {
                Text("Detalii în curând.").foregroundStyle(.secondary)
            }
            Button("Închide") { showRoomSheet = nil }
        }
        .padding()
        .presentationDetents([.medium, .large])
    }

    private func resetTransform() {
        scale = 1; lastScale = 1
        offset = .zero; lastOffset = .zero
    }

    private func recomputePath() {
        guard let s = startNode, let d = destNode, s != d else {
            pathNodeIDs = []; return
        }
        pathNodeIDs = dijkstraShortestPath(graph: Graph(building: building), start: s, goal: d)
    }

    private func handleRoomTap(_ id: String) {
        switch routeStage {
        case .start: startNode = id; routeStage = .dest
        case .dest:  destNode = id; routeStage = .start
        }
        if let s = startNode, let d = destNode, s != d { recomputePath() }
    }
}
