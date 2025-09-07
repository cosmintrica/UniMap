import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss

    @State private var city = Catalog.cities.first ?? ""
    @State private var university = (Catalog.universitiesByCity[Catalog.cities.first ?? ""] ?? []).first ?? ""
    @State private var faculty = (Catalog.facultiesByUniversity[(Catalog.universitiesByCity[Catalog.cities.first ?? ""] ?? []).first ?? ""] ?? []).first ?? ""
    @State private var specialization: String? = nil
    @State private var year: StudyYear = .i
    @State private var email: String = ""

    @FocusState private var focused: Bool

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Brand mic + text
                    HStack(spacing: 12) {
                        Image("unimapIcon").resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("UniMap").font(.title2.bold())
                            Text("Setări inițiale").font(.footnote).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    // Card compact, adaptiv
                    VStack(spacing: 12) {
                        Field("Oraș") {
                            Picker("", selection: $city) {
                                ForEach(Catalog.cities, id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.menu)
                        }
                        Field("Universitatea") {
                            Picker("", selection: $university) {
                                ForEach(Catalog.universitiesByCity[city] ?? [], id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.menu)
                        }
                        Field("Facultatea") {
                            Picker("", selection: $faculty) {
                                ForEach(Catalog.facultiesByUniversity[university] ?? [], id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.menu)
                        }
                        Field("Specializarea (opțional)") {
                            Picker("", selection: Binding(
                                get: { specialization ?? "" },
                                set: { specialization = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("— Niciuna —").tag("")
                                ForEach(Catalog.specializationsByFaculty[faculty] ?? [], id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu)
                        }
                        Field("An") {
                            Picker("", selection: $year) {
                                ForEach(StudyYear.allCases, id: \.self) { Text($0.displayName).tag($0) }
                            }
                            .pickerStyle(.segmented)
                        }
                        Field("Email (opțional)") {
                            TextField("email@exemplu.ro", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .focused($focused)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.primary.opacity(0.08), lineWidth: 1))
                    .frame(maxWidth: 420) // adaptiv (iPhone mic – iPad)

                    Button {
                        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let p = StudentProfile(
                            id: UUID().uuidString,
                            city: city,
                            university: university,
                            faculty: faculty,
                            specialization: specialization,
                            year: year,
                            email: trimmed.isEmpty ? nil : trimmed.lowercased()
                        )
                        profileStore.save(p)
                        dismiss()
                    } label: {
                        Text("Continuă").font(.headline).frame(maxWidth: 420).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(city.isEmpty || university.isEmpty || faculty.isEmpty)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture { focused = false }
        }
        .onChange(of: city) { _, _ in syncUniversityAndBelow() }
        .onChange(of: university) { _, _ in syncFacultyAndBelow() }
        .task { syncUniversityAndBelow() }
    }

    private func syncUniversityAndBelow() {
        let unis = Catalog.universitiesByCity[city] ?? []
        if !unis.contains(university) { university = unis.first ?? "" }
        syncFacultyAndBelow()
    }
    private func syncFacultyAndBelow() {
        let facs = Catalog.facultiesByUniversity[university] ?? []
        if !facs.contains(faculty) { faculty = facs.first ?? "" }
        specialization = nil
    }

    // mic helper pentru aspect unitar
    @ViewBuilder private func Field(_ label: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.footnote).foregroundStyle(.secondary)
            content()
                .padding(.horizontal, 10).padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.tertiarySystemBackground).opacity(0.6)))
        }
    }
}
