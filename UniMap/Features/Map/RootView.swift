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
    @State private var showOnboarding = true
    @State private var mapResetTick = 0

    var body: some View {
        Group {
            if showOnboarding {
                // Afișează doar background-ul când onboarding-ul este activ
                Color(.systemBackground)
                    .ignoresSafeArea(.all)
            } else if profile.isLoading {
                // Loading indicator când se încarcă datele
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Se încarcă...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .ignoresSafeArea(.all)
            } else {
                // Afișează TabView doar când onboarding-ul este complet
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
                .onAppear { 
                    // Încarcă datele educaționale doar dacă utilizatorul este autentificat
                    if profile.isAuthenticated {
                        Task {
                            await profile.loadEducationalDataIfNeededSync()
                        }
                    }
                }
                .onChange(of: selectedTab) { _, newValue in
                    if newValue == .harta { mapResetTick &+= 1 } // revenire pe Harta → reset zoom
                }
            }
        }
        .onChange(of: profile.profile) { _, newValue in 
            showOnboarding = (newValue == nil) 
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            WelcomeView().interactiveDismissDisabled(true)
        }
        .onAppear {
            // Începe încărcarea datelor în background când aplicația se deschide
            // Doar dacă utilizatorul este autentificat
            if profile.isAuthenticated {
                Task {
                    await profile.loadEducationalDataIfNeededSync()
                }
            }
        }
    }
}
