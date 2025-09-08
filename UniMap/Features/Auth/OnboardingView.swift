import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileStore: ProfileStore
    
    @State private var city = Catalog.cities.first ?? ""
    @State private var university = ""
    @State private var faculty = ""
    @State private var specialization: String? = nil
    @State private var year: StudyYear = .i
    @State private var email: String = ""

    @FocusState private var focused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section("Informații Generale") {
                    Picker("Oraș", selection: $city) {
                        ForEach(Catalog.cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }
                
                Section("Informații Academice") {
                    TextField("Universitate", text: $university)
                    TextField("Facultate", text: $faculty)
                    
                    if let spec = specialization {
                        TextField("Specializare", text: Binding(
                            get: { spec },
                            set: { specialization = $0.isEmpty ? nil : $0 }
                        ))
                    } else {
                        TextField("Specializare (opțional)", text: Binding(
                            get: { "" },
                            set: { specialization = $0.isEmpty ? nil : $0 }
                        ))
                    }
                    
                    Picker("An de studiu", selection: $year) {
                        ForEach(StudyYear.allCases, id: \.self) { year in
                            Text("Anul \(year.intValue)").tag(year)
                        }
                    }
                }
                
                Section {
                    Button("Continuă") {
                        let profile = CompleteUserProfile(
                            id: UUID().uuidString,
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            fullName: nil,
                            avatarUrl: nil,
                            university: nil, // TODO: Convert string to University model
                            faculty: nil, // TODO: Convert string to Faculty model
                            specialization: nil, // TODO: Convert string to Specialization model
                            master: nil,
                            studyYear: year,
                            phone: nil,
                            birthDate: nil,
                            bio: nil,
                            preferredLanguage: "ro",
                            notificationsEnabled: true,
                            isAdmin: false
                        )
                        profileStore.save(profile)
                        dismiss()
                    }
                    .disabled(email.isEmpty)
                }
            }
            .navigationTitle("Configurare Inițială")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Anulează") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct Field<Content: View>: View {
    let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            content
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(ProfileStore.shared)
}