//
//  Graph.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import Foundation
import CoreGraphics

struct Graph {
    struct Neighbor { let nodeID: Node.ID; let weight: Double }
    let adjacency: [Node.ID: [Neighbor]]
    let nodes: [Node.ID: Node]

    init(building: Building) {
        var adj: [Node.ID: [Neighbor]] = [:]
        var dict: [Node.ID: Node] = [:]

        for f in building.floors {
            for n in f.nodes { dict[n.id] = n }
            for e in f.edges {
                adj[e.from, default: []].append(.init(nodeID: e.to, weight: e.weight))
                adj[e.to, default: []].append(.init(nodeID: e.from, weight: e.weight)) // neorientat
            }
        }
        self.adjacency = adj
        self.nodes = dict
    }
}

/// Dijkstra: întoarce lista de Node.ID (sau [] dacă nu există drum).
func dijkstraShortestPath(graph: Graph, start: Node.ID, goal: Node.ID) -> [Node.ID] {
    var dist = Dictionary(uniqueKeysWithValues: graph.nodes.keys.map { ($0, Double.infinity) })
    var prev: [Node.ID: Node.ID] = [:]
    var visited: Set<Node.ID> = []
    dist[start] = 0

    while visited.count < graph.nodes.count {
        guard let u = graph.nodes.keys
            .filter({ !visited.contains($0) })
            .min(by: { (dist[$0] ?? .infinity) < (dist[$1] ?? .infinity) }),
            (dist[u] ?? .infinity) < .infinity else { break }

        visited.insert(u)
        if u == goal { break }

        for nb in graph.adjacency[u] ?? [] {
            let alt = (dist[u] ?? .infinity) + nb.weight
            if alt < (dist[nb.nodeID] ?? .infinity) {
                dist[nb.nodeID] = alt
                prev[nb.nodeID] = u
            }
        }
    }

    var path: [Node.ID] = []
    var u: Node.ID? = goal
    while let cur = u, cur != start, let p = prev[cur] {
        path.append(cur); u = p
    }
    if u == start { path.append(start) }
    return path.reversed()
}
