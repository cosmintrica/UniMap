//
//  AdminView.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI
import UniformTypeIdentifiers

struct AdminView: View {
    @State private var showImporter = false
    @State private var imported: [URL] = []

    var body: some View {
        NavigationStack {
            List {
                Section("Unelte") {
                    NavigationLink("Editor hartă (Parter)") { MapEditorView() }
                }
                Section("Fișiere importate") {
                    if imported.isEmpty {
                        Text("—").foregroundStyle(.secondary)
                    } else {
                        ForEach(imported, id: \.self) { url in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(url.lastPathComponent)
                                Text(url.deletingLastPathComponent().lastPathComponent)
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Admin")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Importă JSON") { showImporter = true }
                }
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.json]) { result in
            if case .success(let url) = result { importJSON(url) }
        }
        .onAppear { refresh() }
    }

    private func importJSON(_ url: URL) {
        do {
            let fm = FileManager.default
            let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent("Maps", isDirectory: true)
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            let dest = dir.appendingPathComponent(url.lastPathComponent)
            if fm.fileExists(atPath: dest.path) { try fm.removeItem(at: dest) }
            try fm.copyItem(at: url, to: dest)
            refresh()
        } catch { print("Import error:", error) }
    }

    private func refresh() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Maps", isDirectory: true)
        imported = (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
    }
}
