//
//  AccountView.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var profile: ProfileStore
    @Binding var selectedInstitution: Institution
    @State private var showEdit = false

    var body: some View {
        VStack(spacing: 12) {
            if let p = profile.profile {
                Text(p.displayName).font(.title3.bold())
                Text("\(p.university) – \(p.faculty)")
                    .foregroundStyle(.secondary)
                Button("Editează profil") { showEdit = true }.buttonStyle(.bordered)
            } else {
                Text("Completează profilul pentru a continua")
                    .foregroundStyle(.secondary)
                Button("Începe") { showEdit = true }.buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .sheet(isPresented: $showEdit) { OnboardingView() }
    }
}
