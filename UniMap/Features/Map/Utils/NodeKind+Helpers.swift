//
//  NodeKind+Helpers.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//


import Foundation

// NU mai adăuga: extension Node.Kind: Equatable {}

extension Node.Kind {
    var isRoom: Bool {
        if case .room = self { return true } else { return false }
    }

    var symbolName: String? {
        switch self {
        case .stairs: return "figure.stairs"
        case .entrance: return "door.left.hand.open"
        case .elevator: return "arrow.up.arrow.down.square"
        case .hallway, .room: return nil
        }
    }

    var roomID: String? {
        if case .room(let rid) = self { return rid } else { return nil }
    }
}
