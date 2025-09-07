//
//  RootView.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject private var profile: ProfileStore
    @State private var selectedTab: BottomSection = .harta
    @State private var selectedInstitution: Institution = .ucv
    @State private var showOnboarding = false
    @State private var mapResetTick = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MapScreen(institution: selectedInstitution, resetTick: mapResetTick)
                .tabItem { Label("Harta", systemImage: "map") }
                .tag(BottomSection.harta)

            AnnouncementsView()
                .tabItem { Label("Anunțuri", systemImage: "megaphone") }
                .tag(BottomSection.anunturi)

            AccountView(selectedInstitution: $selectedInstitution)
                .tabItem { Label("Contul meu", systemImage: "person.crop.circle") }
                .tag(BottomSection.contulMeu)

            if profile.isCurrentUserAdmin {
                AdminView()
                    .tabItem { Label("Admin", systemImage: "wrench.and.screwdriver") }
            }
        }
        .onAppear { showOnboarding = (profile.profile == nil) }
        .onChange(of: profile.profile) { _, newValue in showOnboarding = (newValue == nil) }
        .onChange(of: selectedTab) { _, newValue in
            if newValue == .harta { mapResetTick &+= 1 } // revenire pe Harta → reset zoom
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView().interactiveDismissDisabled(true)
        }
    }
}
