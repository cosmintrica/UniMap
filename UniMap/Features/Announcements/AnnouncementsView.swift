//
//  AnnouncementsView.swift
//  UniMap
//

import SwiftUI
import Supabase

struct AnnouncementsView: View {
    @EnvironmentObject private var profile: ProfileStore
    @State private var expandedID: UUID? = nil
    @State private var announcements: [Announcement] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var lastRefreshTime = Date()
    
    private let supabase = SupabaseManager.shared

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Se încarcă anunțurile...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("Eroare la încărcarea anunțurilor")
                        .font(.headline)
                    
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Încearcă din nou") {
                        Task {
                            await loadAnnouncements()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                let yearInt = profile.profile?.studyYear?.intValue ?? 3
                let filteredAnnouncements = announcements.filter { announcement in
                    // Filtrează anunțurile active și care se aplică pentru anul studentului
                    announcement.isActive && 
                    (announcement.priority == .urgent || 
                     announcement.targetStudyYear == nil || 
                     announcement.targetStudyYear == yearInt)
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Pull to refresh indicator
                        if isRefreshing {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Se actualizează anunțurile...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        ForEach(filteredAnnouncements) { item in
                            AnnouncementCard(
                                item: item,
                                isExpanded: expandedID == item.id,
                                onToggle: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        expandedID = (expandedID == item.id) ? nil : item.id
                                    }
                                }
                            )
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                }
                .refreshable {
                    await refreshAnnouncements()
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Anunțuri")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await refreshAnnouncements()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.accentColor)
                }
                .disabled(isRefreshing)
            }
        }
        .task {
            await loadAnnouncements()
        }
    }
    
    private func loadAnnouncements() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Announcement] = try await supabase.client
                .from("announcements")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            await MainActor.run {
                self.announcements = response
                self.isLoading = false
                self.lastRefreshTime = Date()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func refreshAnnouncements() async {
        isRefreshing = true
        errorMessage = nil
        
        do {
            let response: [Announcement] = try await supabase.client
                .from("announcements")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            await MainActor.run {
                self.announcements = response
                self.isRefreshing = false
                self.lastRefreshTime = Date()
            }
        } catch {
            // Ignoră erorile de "cancelled" care apar când utilizatorul face pull-to-refresh
            if !error.localizedDescription.contains("cancelled") && !error.localizedDescription.contains("canceled") {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            
            await MainActor.run {
                self.isRefreshing = false
            }
        }
    }
}

private struct AnnouncementCard: View {
    let item: Announcement
    let isExpanded: Bool
    var onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header cu prioritate
            HStack {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                // Badge pentru prioritate
                Text(item.priority.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(item.priority.color).opacity(0.2))
                    .foregroundColor(Color(item.priority.color))
                    .clipShape(Capsule())
            }

            // Conținut
            Text(isExpanded ? item.content : String(item.content.prefix(100)) + "...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(isExpanded ? nil : 3)

            // Imagine dacă există
            if let imageURL = item.imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(height: 120)
                        .overlay {
                            ProgressView()
                        }
                }
            }

            // Footer cu informații
            HStack {
                Text("Creat: \(item.createdAt, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let expiresAt = item.expiresAt {
                    Text("Expiră: \(expiresAt, style: .date)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }

            // Buton pentru expand/collapse
            Button(isExpanded ? "Ascunde" : "Citește mai mult", action: onToggle)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.separator, lineWidth: 0.5)
        )
        .contentShape(Rectangle())
        .onTapGesture { onToggle() }
    }
}
