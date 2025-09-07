//
//  StairsLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import SwiftUI

struct StairsLayer: View {
    let floor: Floor
    let canvasSize: CGSize

    var body: some View {
        ForEach(floor.stairs) { s in
            IndoorPolygon(points: s.points)
                .fill(Color.gray.opacity(0.15))
                .overlay(IndoorPolygon(points: s.points)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1))
                .zIndex(2)
        }
    }
}
