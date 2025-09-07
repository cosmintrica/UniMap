//
//  CampusOverviewView.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI
import MapKit

struct CampusOverviewView: View {
    var onEnterBuilding: () -> Void

    @StateObject private var loc = LocationManager()
    @State private var hasRequestedLocation = false

    // UCV coordonate aprox
    private let ucv = CLLocationCoordinate2D(latitude: 44.31853, longitude: 23.80095)

    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 44.31853, longitude: 23.80095),
                           span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    )

    var body: some View {
        ZStack {
            Map(position: $position, interactionModes: [.all]) {
                // pin UCV (tap -> intră)
                Annotation("Universitatea din Craiova", coordinate: ucv) {
                    Button {
                        withAnimation(.spring) { onEnterBuilding() }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "building.columns.fill")
                                .imageScale(.large)
                                .font(.title2.weight(.semibold))
                            Text("Universitatea din Craiova")
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(radius: 4)
                    }
                    .buttonStyle(.plain)
                }


                // punctul utilizatorului (dacă există)
                if let c = loc.location?.coordinate {
                    Annotation("Tu", coordinate: c) {
                        Image(systemName: "location.fill")
                            .font(.title3)
                            .padding(6)
                            .background(.ultraThinMaterial, in: Circle())
                            .shadow(radius: 2)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear { 
                // Nu cere locația automat - doar când utilizatorul apasă butonul
                // loc.request() - ELIMINAT pentru a preveni cererea automată
            }

            // butoane utile peste hartă
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Button {
                            position = .region(MKCoordinateRegion(center: ucv,
                                     span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)))
                        } label: { Image(systemName: "building.2.crop.circle") }
                        .buttonStyle(.bordered)

                        Button {
                            if let c = loc.location?.coordinate {
                                position = .region(MKCoordinateRegion(center: c,
                                         span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)))
                            } else {
                                // Cere locația doar când utilizatorul apasă butonul
                                if !hasRequestedLocation {
                                    hasRequestedLocation = true
                                    loc.request()
                                }
                            }
                        } label: { 
                            Image(systemName: loc.location != nil ? "location.circle.fill" : "location.circle")
                                .foregroundColor(loc.location != nil ? .green : .blue)
                        }
                        .buttonStyle(.bordered)
                        .disabled(loc.authorization == .denied || loc.authorization == .restricted)
                    }
                    .padding(10)
                }
                Spacer()
            }
        }
    }
}
