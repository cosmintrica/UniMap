//
//  AppTypes.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import Foundation
import CoreGraphics

enum BottomSection { case harta, anunturi, contulMeu }

enum Institution: String, CaseIterable, Identifiable {
    case ucv
    var id: String { rawValue }
    var displayName: String { "Universitatea din Craiova" }
}

// ATENȚIE: nu mai declara aici "nearestNavigableNode(to:floor:)"
// Funcția oficială e în Features/Map/Models/Building.swift (extensie Building).

// Dacă ai nevoie de o variantă care EXCLUDE camerele (.room),
// păstrează-o cu un NUME DIFERIT, ca mai jos:
extension Building {
    /// Variantă utilitară: cel mai apropiat nod NON-room pe etajul dat.
    func nearestNonRoomNode(to point: CGPoint, floor floorId: Int) -> Node? {
        let nodesOnFloor = floors.first(where: { $0.id == floorId })?.nodes ?? []
        return nodesOnFloor
            .filter { if case .room = $0.kind { return false } else { return true } }
            .min(by: { $0.point.distance(to: point) < $1.point.distance(to: point) })
    }
}
