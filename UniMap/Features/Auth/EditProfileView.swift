//
//  EditProfileView.swift
//  UniMap
//
//  Created by Cosmin Trica on 09.09.2025.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileStore: ProfileStore
    
    // Personal Information
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var bio: String = ""
    @State private var birthDate: Date = Date()
    
    // Educational Information
    @State private var selectedUniversity: University?
    @State private var selectedFaculty: Faculty?
    @State private var selectedSpecialization: Specialization?
    @State private var selectedMaster: Master?
    @State private var selectedStudyYear: StudyYear = .i
    
    // UI State
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Personal Information Section
                Section("Informații Personale") {
                    TextField("Nume complet", text: $fullName)
                        .textContentType(.name)
                    
                    TextField("Telefon", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    
                    DatePicker("Data nașterii", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Despre mine")
                            .font(.subheadline.weight(.medium))
                        TextEditor(text: $bio)
                            .frame(minHeight: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
                
                // Educational Information Section
                Section("Informații Educaționale") {
                    Picker("Universitate", selection: $selectedUniversity) {
                        Text("Selectează universitatea").tag(nil as University?)
                        ForEach(profileStore.universities, id: \.id) { university in
                            Text(university.name).tag(university as University?)
                        }
                    }
                    
                    Picker("Facultate", selection: $selectedFaculty) {
                        Text("Selectează facultatea").tag(nil as Faculty?)
                        ForEach(profileStore.faculties, id: \.id) { faculty in
                            Text(faculty.name).tag(faculty as Faculty?)
                        }
                    }
                    .disabled(selectedUniversity == nil)
                    
                    Picker("Specializare", selection: $selectedSpecialization) {
                        Text("Selectează specializarea").tag(nil as Specialization?)
                        ForEach(profileStore.specializations, id: \.id) { specialization in
                            Text(specialization.name).tag(specialization as Specialization?)
                        }
                    }
                    .disabled(selectedFaculty == nil)
                    
                    Picker("Master", selection: $selectedMaster) {
                        Text("Nu fac master").tag(nil as Master?)
                        ForEach(profileStore.masters, id: \.id) { master in
                            Text(master.name).tag(master as Master?)
                        }
                    }
                    
                    Picker("Anul de studiu", selection: $selectedStudyYear) {
                        ForEach(StudyYear.allCases, id: \.self) { year in
                            Text(year.displayName).tag(year)
                        }
                    }
                }
                
                // Preferences Section
                Section("Preferințe") {
                    Toggle("Notificări activate", isOn: .constant(true))
                        .disabled(true) // Pentru moment, nu permit modificarea
                    
                    Picker("Limbă preferată", selection: .constant("ro")) {
                        Text("Română").tag("ro")
                        Text("English").tag("en")
                    }
                    .disabled(true) // Pentru moment, nu permit modificarea
                }
            }
            .navigationTitle("Editează Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anulează") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvează") {
                        Task {
                            await saveProfile()
                        }
                    }
                    .disabled(isLoading)
                }
            }
        }
        .onAppear {
            loadCurrentProfile()
            Task {
                await profileStore.loadEducationalDataIfNeeded()
            }
        }
        .alert("Eroare", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "A apărut o eroare la salvarea profilului.")
        }
    }
    
    private func loadCurrentProfile() {
        guard let profile = profileStore.profile else { return }
        
        fullName = profile.fullName ?? ""
        phone = profile.phone ?? ""
        bio = profile.bio ?? ""
        birthDate = profile.birthDate ?? Date()
        
        selectedUniversity = profile.university
        selectedFaculty = profile.faculty
        selectedSpecialization = profile.specialization
        selectedMaster = profile.master
        selectedStudyYear = profile.studyYear ?? .i
    }
    
    private func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        let update = ProfileUpdate(
            fullName: fullName.isEmpty ? nil : fullName,
            phone: phone.isEmpty ? nil : phone,
            birthDate: birthDate,
            bio: bio.isEmpty ? nil : bio,
            universityId: selectedUniversity?.id,
            facultyId: selectedFaculty?.id,
            specializationId: selectedSpecialization?.id,
            masterId: selectedMaster?.id,
            studyYear: selectedStudyYear.intValue,
            preferredLanguage: "ro",
            notificationsEnabled: true
        )
        
        await profileStore.updateProfile(update)
        
        await MainActor.run {
            isLoading = false
            if profileStore.errorMessage != nil {
                errorMessage = profileStore.errorMessage
                showingError = true
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(ProfileStore.shared)
}
