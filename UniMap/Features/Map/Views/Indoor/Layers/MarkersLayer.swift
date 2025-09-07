//
//   MarkersLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import SwiftUI

struct MarkersLayer: View {
    let floor: Floor
    let building: Building
    let canvasSize: CGSize
    let startNode: String?
    let destNode: String?

    var body: some View {
        Group {
            if let s = startNode, let n = building.nodeLookup[s], n.floor == floor.id {
                marker(color: .green, label: "Start")
                    .position(n.point.indoorScaled(to: canvasSize))
            }
            if let d = destNode, let n = building.nodeLookup[d], n.floor == floor.id {
                marker(color: .red, label: "Dest")
                    .position(n.point.indoorScaled(to: canvasSize))
            }
        }
        .zIndex(6)
    }

    private func marker(color: Color, label: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: Capsule())
            Circle()
                .fill(color)
                .frame(width: 18, height: 18)
                .shadow(radius: 3)
        }
    }
}
