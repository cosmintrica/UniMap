//
//  FloorPicker.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//


import SwiftUI

struct FloorPicker: View {
    @Binding var currentFloorIndex: Int      // mapează: -2,-1,0,1,2,3
    @State private var expanded = false

    private let floors: [Int] = [-2, -1, 0, 1, 2, 3]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if expanded {
                ForEach(floors, id: \.self) { f in
                    floorPill(f)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                currentFloorIndex = f
                                expanded = false
                            }
                        }
                }
            } else {
                floorPill(currentFloorIndex)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            expanded = true
                        }
                    }
            }
        }
    }

    private func floorPill(_ f: Int) -> some View {
        Text(label(for: f))
            .font(.footnote.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .shadow(radius: 3)
    }

    private func label(for f: Int) -> String {
        switch f {
        case -2: return "-2"
        case -1: return "-1"
        case 0:  return "Parter"
        default: return "Etaj \(f)"
        }
    }
}
