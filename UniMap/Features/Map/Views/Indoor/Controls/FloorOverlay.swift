//
//  FloorPicker.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import SwiftUI

struct FloorOverlay: View {
    let floors: [String]
    @Binding var current: Int
    @State private var expanded = false

    var body: some View {
        // containerul ocupă tot ecranul, dar conținutul e jos-centru
        ZStack(alignment: .bottom) {
            // mic blur jos (opțional)
            LinearGradient(stops: [
                .init(color: .clear, location: 0.0),
                .init(color: .black.opacity(0.06), location: 1.0),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(alignment: .center, spacing: 6) {
                if expanded {
                    ForEach(floors.indices, id: \.self) { i in
                        floorPill(title: floors[i], selected: i == current)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    current = i
                                    expanded = false
                                }
                            }
                    }
                } else {
                    floorPill(title: floors[current], selected: true)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                expanded = true
                            }
                        }
                }
            }
            .padding(.bottom, 20)              // distanță față de marginea de jos
            .frame(maxWidth: .infinity)
        }
        // îl folosim ca overlay, deci nu setăm alignment aici; se face din părinte
    }

    private func floorPill(title: String, selected: Bool) -> some View {
        Text(title)
            .font(.footnote.bold())
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(selected ? Color.primary.opacity(0.25) : Color.secondary.opacity(0.15)))
            .shadow(radius: 3)
    }
}
