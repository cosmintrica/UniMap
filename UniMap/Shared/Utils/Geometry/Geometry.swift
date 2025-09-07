//
//  PolygonShape.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import CoreGraphics
import SwiftUI

extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint { .init(x: x * size.width, y: y * size.height) }
    func indoorScaled(to size: CGSize) -> CGPoint { scaled(to: size) }   // alias unic în proiect
    func distance(to other: CGPoint) -> CGFloat { hypot(x - other.x, y - other.y) }
}

struct IndoorPolygon: Shape {
    let points: [CGPoint]
    func path(in rect: CGRect) -> Path {
        var p = Path()
        guard points.count > 1 else { return p }
        p.addLines(points.map { $0.scaled(to: rect.size) })
        p.closeSubpath()
        return p
    }
}
