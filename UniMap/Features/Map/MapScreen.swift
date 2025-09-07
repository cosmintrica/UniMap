//
//  MapScreen.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import SwiftUI

struct MapScreen: View {
    let institution: Institution
    var resetTick: Int = 0

    @State private var showIndoor = false
    @State private var currentFloorIndex: Int = 0
    @State private var startNode: String? = nil
    @State private var destNode: String? = nil
    @State private var pathNodeIDs: [String] = []

    private var building: Building { UCVData.building }

    var body: some View {
        ZStack {
            // Harta / Campus
            if showIndoor {
                IndoorMapView(
                    building: building,
                    currentFloorIndex: $currentFloorIndex,
                    startNode: $startNode,
                    destNode: $destNode,
                    pathNodeIDs: $pathNodeIDs,
                    onExitRequested: { resetToCampus() }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                        removal: .opacity))
            } else {
                CampusOverviewView {
                    withAnimation(.spring) {
                        showIndoor = true
                        if let idx = building.floors.firstIndex(where: { $0.id == 0 }) {
                            currentFloorIndex = idx
                        }
                    }
                }
            }
        }
        // ── SUS-STÂNGA: legendă + resetează
        .overlay(alignment: .topLeading) {
            if showIndoor {
                selectionPills
                    .padding(.top, 8)
                    .padding(.leading, 12)
            }
        }
        // ── JOS-CENTRU: floor picker
        .overlay(alignment: .bottom) {
            if showIndoor {
                FloorOverlay(
                    floors: building.floors.map { $0.name },   // ⇦ evită keypath-ul
                    current: $currentFloorIndex
                )
                .padding(.bottom, 12)
            }
        }
        // ── JOS-STÂNGA: buton “Înapoi”
        .overlay(alignment: .bottomLeading) {
            if showIndoor {
                Button {
                    resetToCampus()
                } label: {
                    Label("Înapoi", systemImage: "chevron.backward")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.mini)
                .tint(.accentColor)
                .padding(.leading, 12)
                .padding(.bottom, 12)
            }
        }
        .onAppear {
            if let idx = building.floors.firstIndex(where: { $0.id == 0 }) {
                currentFloorIndex = idx
            }
        }
        .onChange(of: resetTick) {   // noul API (iOS 17+)
            resetToCampus()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: showIndoor)
    }

    // legendă minimală
    private var selectionPills: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Circle().fill(.green).frame(width: 10, height: 10)
                Text(startNode == nil ? "Alege Start (tap pe hartă)" : "Start setat")
                    .font(.caption2).foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                Circle().fill(.red).frame(width: 10, height: 10)
                Text(destNode == nil ? "Alege Destinația" : "Destinație setată")
                    .font(.caption2).foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                Button {
                    startNode = nil; destNode = nil; pathNodeIDs = []
                } label: { Label("Resetează", systemImage:"xmark.circle") }
                .buttonStyle(.bordered)
                .controlSize(.mini)
                .disabled(startNode == nil && destNode == nil)
            }
        }
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.separator, lineWidth: 0.5))
    }

    private func resetToCampus() {
        withAnimation(.spring) {
            showIndoor = false
            currentFloorIndex = 2
            startNode = nil
            destNode = nil
            pathNodeIDs = []
        }
    }
}
