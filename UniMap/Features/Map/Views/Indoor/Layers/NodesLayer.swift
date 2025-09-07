//
//  NodesLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//


import SwiftUI

struct NodesLayer: View {
    let floor: Floor
    let canvasSize: CGSize
    let startNode: String?
    let destNode: String?
    // chemat doar când atingi un nod de tip .room
    var onRoomNodeTapped: (String) -> Void = { _ in }

    var body: some View {
        ForEach(floor.nodes) { n in
            let pt = n.point.indoorScaled(to: canvasSize)

            Circle()
                .fill(color(for: n))
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                .position(pt)
                .onTapGesture {
                    if case .room = n.kind { onRoomNodeTapped(n.id) }
                }
                .zIndex(4)

            if let symbol = symbolName(for: n.kind) {
                Label("", systemImage: symbol)
                    .labelStyle(.iconOnly)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(6)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(radius: 3)
                    .position(pt)
                    .zIndex(5)
            }
        }
    }

    private func color(for n: Node) -> Color {
        if n.id == startNode { return .green }
        if n.id == destNode { return .red }
        switch n.kind {
        case .hallway: return .blue.opacity(0.8)
        case .stairs: return .orange
        case .entrance: return .purple
        case .elevator: return .indigo
        case .room: return .gray
        }
    }

    private func symbolName(for kind: Node.Kind) -> String? {
        switch kind {
        case .stairs: return "figure.stairs"
        case .entrance: return "door.left.hand.open"
        case .elevator: return "arrow.up.arrow.down.square"
        case .hallway, .room: return nil
        }
    }
}
