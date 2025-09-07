//
//  GraphEdgesLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//


import SwiftUI

struct GraphEdgesLayer: View {
    let floor: Floor
    let building: Building
    let canvasSize: CGSize

    var body: some View {
        Path { path in
            for e in floor.edges {
                guard
                    let a = building.nodeLookup[e.from],
                    let b = building.nodeLookup[e.to],
                    a.floor == floor.id, b.floor == floor.id
                else { continue }

                path.move(to: a.point.indoorScaled(to: canvasSize))
                path.addLine(to: b.point.indoorScaled(to: canvasSize))
            }
        }
        .stroke(Color.secondary.opacity(0.35),
                style: StrokeStyle(lineWidth: 2, lineCap: .round))
        .zIndex(2)
    }
}
