//
//  IndoorMapViewModel.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//


import SwiftUI

@MainActor
final class IndoorMapViewModel: ObservableObject {
    let building: Building
    @Published var currentFloorIndex: Int
    @Published var startNode: Node.ID?
    @Published var destNode: Node.ID?
    @Published var pathNodeIDs: [Node.ID] = []
    @Published var scale: CGFloat = 1
    @Published var offset: CGSize = .zero

    init(building: Building, currentFloorIndex: Int = 0) {
        self.building = building
        self.currentFloorIndex = currentFloorIndex
    }

    func resetTransform() { scale = 1; offset = .zero }
    func recomputePath() {
        guard let s = startNode, let d = destNode, s != d else { pathNodeIDs = []; return }
        let g = Graph(building: building)
        pathNodeIDs = dijkstraShortestPath(graph: g, start: s, goal: d)
    }
}
