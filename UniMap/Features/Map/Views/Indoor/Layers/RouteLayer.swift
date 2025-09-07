//
//  RouteLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import SwiftUI

struct RouteLayer: View {
    let floor: Floor
    let building: Building
    let canvasSize: CGSize
    let pathNodeIDs: [String]

    var body: some View {
        Path { p in
            guard pathNodeIDs.count > 1 else { return }
            for i in 0..<(pathNodeIDs.count - 1) {
                let nid = pathNodeIDs[i], nid2 = pathNodeIDs[i+1]
                guard
                    let a = building.nodeLookup[nid],
                    let b = building.nodeLookup[nid2],
                    a.floor == floor.id, b.floor == floor.id
                else { continue }

                p.move(to: a.point.indoorScaled(to: canvasSize))
                p.addLine(to: b.point.indoorScaled(to: canvasSize))
            }
        }
        .stroke(Color.accentColor, style: .init(lineWidth: 6, lineCap: .round))
        .shadow(color: .accentColor.opacity(0.35), radius: 6)
        .zIndex(3)
    }
}
