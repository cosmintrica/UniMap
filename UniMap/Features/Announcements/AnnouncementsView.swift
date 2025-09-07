//
//  AnnouncementsView.swift
//  UniMap
//

import SwiftUI

struct Announcement: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let bannerName: String   // Image Set în Assets (ex: "netrom_banner")
    let preview: String
    let fullText: String
    let minYear: Int
    let maxYear: Int
    let link: URL?
    let phone: String?
}

private let allAnnouncements: [Announcement] = [
    Announcement(
        title: "Netrom – Oportunități pentru studenți",
        bannerName: "netrom_banner",
        preview: "Programe de practică plătită, proiecte reale și mentorat.",
        fullText: "Netrom oferă stagii plătite, proiecte reale și oportunități de angajare după finalizarea stagiului. Vei lucra cu tehnologii moderne și vei avea mentor dedicat.",
        minYear: 1, maxYear: 6,
        link: nil,
        phone: nil
    ),
    Announcement(
        title: "Hella – Internship avansat (ani 3–4)",
        bannerName: "hella_banner",
        preview: "Internship pe embedded & automotive pentru studenții din anii 3 și 4.",
        fullText: """
Hella lansează un program intensiv pe embedded/automotive pentru studenții din anii 3 și 4.
Vei lucra pe proiecte reale, cu mentori dedicați și acces la echipamente moderne.
Mai multe detalii pe site-ul oficial sau la numărul de telefon de mai jos.
""",
        minYear: 3, maxYear: 4,
        link: URL(string: "https://www.hella.com"),
        phone: "+40 251 123 456"
    )
]

struct AnnouncementsView: View {
    @EnvironmentObject private var profile: ProfileStore
    @State private var expandedID: UUID? = nil

    var body: some View {
        let yearInt = (Int(profile.profile?.year.rawValue ?? "3") ?? 3)
        let items = allAnnouncements.filter { yearInt >= $0.minYear && yearInt <= $0.maxYear }

        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
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
            .buttonStyle(.plain) // previne conflicte de tap între card și butonul intern
            .navigationTitle("Anunțuri")
        }
    }
}

private struct AnnouncementCard: View {
    let item: Announcement
    let isExpanded: Bool
    var onToggle: () -> Void

    /// cât de “subțire” vrei bannerul; 3.2 arată bine pe toate device-urile
    private let bannerRatio: CGFloat = 3.2 // width : height

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Banner: aceeași înălțime relativă peste tot, fără crop/deformare
            ZStack {
                // fundal minim, ca să nu “sară” vizual dacă bannerul are transparențe
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.06))

                Image(item.bannerName)
                    .resizable()
                    .scaledToFit()            // ⇦ NU taie, NU deformează
                    .padding(6)               // mic “safeguard” față de margini
            }
            .aspectRatio(bannerRatio, contentMode: .fit) // ⇦ controlează înălțimea în funcție de lățime

            // Titlu + text – stil iOS “curat”
            Text(item.title)
                .font(.headline)

            Text(isExpanded ? item.fullText : item.preview)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if isExpanded {
                HStack(spacing: 8) {
                    if let url = item.link {
                        Link("Deschide link", destination: url).buttonStyle(.bordered)
                    }
                    if let phone = item.phone {
                        Button { /* ex: tel:// */ } label: {
                            Label(phone, systemImage: "phone")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            Button(isExpanded ? "Ascunde" : "Citește mai mult", action: onToggle)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .frame(maxWidth: .infinity)  // ⇦ centrat

        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.separator, lineWidth: 0.5) // hairline discret (fără shadow)
        )
        .contentShape(Rectangle())
        .onTapGesture { onToggle() }
    }
}
