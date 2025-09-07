//
//  Building.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import CoreGraphics
import Foundation

extension Building {
    /// Cel mai apropiat nod navigabil de un punct pe etajul dat.
    /// Preferă .room; dacă nu există, caută în toate nodurile etajului.
    func nearestNavigableNode(to point: CGPoint, floor floorId: Int) -> Node? {
        let nodesOnFloor = floors.first(where: { $0.id == floorId })?.nodes ?? []

        let roomNodes = nodesOnFloor.filter { if case .room = $0.kind { return true } else { return false } }
        let pool = roomNodes.isEmpty ? nodesOnFloor : roomNodes

        return pool.min(by: { $0.point.distance(to: point) < $1.point.distance(to: point) })
    }
}
