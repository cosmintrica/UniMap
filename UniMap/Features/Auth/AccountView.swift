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
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let p = profile.profile {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Avatar
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Text(String(p.displayName.prefix(1)).uppercased())
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            
                            // Name and Email
                            VStack(spacing: 4) {
                                Text(p.displayName)
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                                
                                Text(p.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Educational Information
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Informații Educaționale")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                InfoRow(
                                    icon: "building.2",
                                    title: "Universitate",
                                    value: p.university?.name ?? "Nu este selectată",
                                    color: Color.blue,
                                    isEditing: isEditing
                                )
                                
                                InfoRow(
                                    icon: "graduationcap",
                                    title: "Facultate",
                                    value: p.faculty?.name ?? "Nu este selectată",
                                    color: Color.green
                                )
                                
                                InfoRow(
                                    icon: "book",
                                    title: "Specializare",
                                    value: p.specialization?.name ?? "Nu este selectată",
                                    color: Color.orange
                                )
                                
                                if let master = p.master {
                                    InfoRow(
                                        icon: "star",
                                        title: "Master",
                                        value: master.name,
                                        color: Color.purple
                                    )
                                }
                                
                                InfoRow(
                                    icon: "calendar",
                                    title: "Anul de studiu",
                                    value: p.studyYear?.displayName ?? "Nu este selectat",
                                    color: Color.red
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                        )
                        
                        // Personal Information
                        if p.phone != nil || p.bio != nil {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Informații Personale")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                VStack(spacing: 12) {
                                    if let phone = p.phone {
                                        InfoRow(
                                            icon: "phone",
                                            title: "Telefon",
                                            value: phone,
                                            color: Color.blue
                                        )
                                    }
                                    
                                    if let bio = p.bio, !bio.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: "person.text.rectangle")
                                                    .foregroundColor(Color.green)
                                                    .frame(width: 20)
                                                Text("Despre mine")
                                                    .font(.subheadline.weight(.medium))
                                                Spacer()
                                            }
                                            Text(bio)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        
                        // Edit Button
                        Button(isEditing ? "Salvează" : "Editează Profil") {
                            if isEditing {
                                Task {
                                    await saveProfile()
                                }
                            } else {
                                isEditing = true
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isEditing ? Color.green : Color.accentColor)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 20)
                        
                    } else {
                        // No Profile State
                        VStack(spacing: 20) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text("Completează profilul")
                                .font(.title2.bold())
                            
                            Text("Creează-ți contul pentru o experiență personalizată")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Începe") {
                                showEdit = true
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                            .padding(.horizontal, 40)
                        }
                        .padding(.top, 60)
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Contul meu")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showEdit) { 
            EditProfileView()
                .environmentObject(profile)
        }
    }
    
    private func saveProfile() async {
        // TODO: Implement save functionality
        isEditing = false
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    var isEditing: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                
                if isEditing {
                    TextField("Introduceți \(title.lowercased())", text: .constant(value))
                        .textFieldStyle(.roundedBorder)
                        .font(.subheadline)
                } else {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}
