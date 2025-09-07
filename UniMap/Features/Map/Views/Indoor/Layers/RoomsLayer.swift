//
//  RoomsLayer.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

// Views/Indoor/Layers/RoomsLayer.swift
import SwiftUI

struct RoomsLayer: View {
    let floor: Floor
    let building: Building
    let canvasSize: CGSize
    // (room, center, nearestNavigableNodeId)
    var onRoomTapped: (RoomPolygon, CGPoint, String?) -> Void = { _,_,_ in }

    var body: some View {
        // forțează init-ul ForEach cu id explicit ca să eliminăm ambiguitatea
        ForEach(floor.rooms, id: \.id) { room in
            roomView(room)
        }
    }

    @ViewBuilder
    private func roomView(_ room: RoomPolygon) -> some View {
        let center = room.center.indoorScaled(to: canvasSize)

        ZStack {
            IndoorPolygon(points: room.points)
                .fill(Color.primary.opacity(0.06))
                .overlay(
                    IndoorPolygon(points: room.points)
                        .stroke(Color.primary.opacity(0.18), lineWidth: 1)
                )
                .contentShape(IndoorPolygon(points: room.points))
                .onTapGesture {
                    let nid = building.nearestNavigableNode(to: room.center, floor: room.floor)?.id
                    onRoomTapped(room, center, nid)
                }
                .zIndex(1)

            Text(room.name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .position(center)
                .zIndex(2)
        }
    }
}

// dacă ai un #Preview în fișier și tot apar erori ciudate,
// comentează-l temporar sau pune-l sub #if DEBUG.
