//
//  PolygonShape.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import SwiftUI
import CoreGraphics
import Foundation

// MARK: - Data models

struct RoomPolygon: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let floor: Int
    let points: [CGPoint]
    let info: String?

    var center: CGPoint {
        guard !points.isEmpty else { return .zero }
        var sx: CGFloat = 0, sy: CGFloat = 0
        for p in points { sx += p.x; sy += p.y }
        return CGPoint(x: sx / CGFloat(points.count), y: sy / CGFloat(points.count))
    }
}

struct AreaPolygon: Identifiable, Hashable, Codable {
    let id: String
    let points: [CGPoint]
}

struct Node: Identifiable, Codable {
    enum Kind: Codable, Equatable {
        case hallway
        case room(String)
        case stairs(String)
        case entrance(String)
        case elevator(String)

        private enum K: String, Codable { case hallway, room, stairs, entrance, elevator }
        enum CodingKeys: String, CodingKey { case t, v }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            switch try c.decode(K.self, forKey: .t) {
            case .hallway: self = .hallway
            case .room:    self = .room(try c.decode(String.self, forKey: .v))
            case .stairs:  self = .stairs(try c.decode(String.self, forKey: .v))
            case .entrance:self = .entrance(try c.decode(String.self, forKey: .v))
            case .elevator:self = .elevator(try c.decode(String.self, forKey: .v))
            }
        }
        func encode(to encoder: Encoder) throws {
            var c = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .hallway: try c.encode(K.hallway, forKey: .t)
            case .room(let s): try c.encode(K.room, forKey: .t); try c.encode(s, forKey: .v)
            case .stairs(let s): try c.encode(K.stairs, forKey: .t); try c.encode(s, forKey: .v)
            case .entrance(let s): try c.encode(K.entrance, forKey: .t); try c.encode(s, forKey: .v)
            case .elevator(let s): try c.encode(K.elevator, forKey: .t); try c.encode(s, forKey: .v)
            }
        }
    }

    typealias ID = String
    let id: ID
    let floor: Int
    let point: CGPoint
    let kind: Kind
}

struct Edge: Hashable, Codable {
    let from: Node.ID
    let to: Node.ID
    let weight: Double
}

struct Floor: Identifiable, Codable {
    let id: Int
    let name: String
    var rooms: [RoomPolygon]
    var nodes: [Node]
    var edges: [Edge]
    var corridors: [AreaPolygon] = []
    var stairs: [AreaPolygon] = []
}

struct Building: Identifiable, Codable {
    let id: String
    let name: String
    let floors: [Floor]

    var nodeLookup: [Node.ID: Node] {
        floors.flatMap(\.nodes).reduce(into: [:]) { $0[$1.id] = $1 }
    }
    var roomLookup: [String: RoomPolygon] {
        floors.flatMap(\.rooms).reduce(into: [:]) { $0[$1.id] = $1 }
    }
}
