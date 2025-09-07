import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileStore: ProfileStore
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var phone = ""
    
    // Educational data
    @State private var selectedUniversity: University?
    @State private var selectedFaculty: Faculty?
    @State private var selectedSpecialization: Specialization?
    @State private var selectedMaster: Master?
    @State private var selectedStudyYear: StudyYear = .i
    
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var showLogin = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerView
                    
                    // Form
                    formView
                    
                    // Buttons
                    buttonsView
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
        .onAppear {
            Task {
                await profileStore.loadEducationalDataIfNeeded()
            }
        }
        .alert("Eroare", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Creează-ți contul")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundColor(.primary)
            
            Text("Completează informațiile pentru a începe")
                .font(.system(size: 17, weight: .regular, design: .default))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            // Personal Information
            personalInfoSection
            
            // Educational Information
            educationalInfoSection
        }
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informații Personale")
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                SimpleTextField(title: "Nume complet", text: $fullName, placeholder: "Introdu numele tău complet")
                SimpleTextField(title: "Email", text: $email, placeholder: "nume@exemplu.com")
                SimpleTextField(title: "Telefon (opțional)", text: $phone, placeholder: "+40 123 456 789")
                SimpleSecureField(title: "Parolă", text: $password, placeholder: "Minim 6 caractere")
                SimpleSecureField(title: "Confirmă parola", text: $confirmPassword, placeholder: "Repetă parola")
            }
        }
    }
    
    private var educationalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informații Academice")
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                SimplePicker(
                    title: "Universitate",
                    selection: $selectedUniversity,
                    options: profileStore.universities
                ) { $0.name }
                
                if let university = selectedUniversity {
                    SimplePicker(
                        title: "Facultate",
                        selection: $selectedFaculty,
                        options: profileStore.faculties.filter { $0.universityId == university.id }
                    ) { $0.name }
                }
                
                if let faculty = selectedFaculty {
                    SimplePicker(
                        title: "Specializare",
                        selection: $selectedSpecialization,
                        options: profileStore.specializations.filter { $0.facultyId == faculty.id }
                    ) { $0.name }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("An de studiu")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.primary)
                    
                    Menu {
                        ForEach(StudyYear.allCases, id: \.self) { year in
                            Button(year.displayName) {
                                selectedStudyYear = year
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedStudyYear.displayName)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 12) {
            Button(action: signUp) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text("Creează contul")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(canSignUp ? Color.accentColor : Color.accentColor.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!canSignUp || isLoading)
            
            Button("Ai deja cont? Conectează-te") {
                showLogin = true
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.secondary)
            .frame(height: 44)
        }
    }
    
    private var canSignUp: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        password == confirmPassword && 
        password.count >= 6 &&
        selectedUniversity != nil &&
        selectedFaculty != nil
    }
    
    private func signUp() {
        guard canSignUp else { return }
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let profile = CompleteUserProfile(
                    id: UUID().uuidString,
                    email: email.lowercased(),
                    fullName: fullName.isEmpty ? nil : fullName,
                    avatarUrl: nil,
                    university: selectedUniversity,
                    faculty: selectedFaculty,
                    specialization: selectedSpecialization,
                    master: selectedMaster,
                    studyYear: selectedStudyYear,
                    phone: phone.isEmpty ? nil : phone,
                    birthDate: nil,
                    bio: nil,
                    preferredLanguage: "ro",
                    notificationsEnabled: true
                )
                
                try await profileStore.signUp(email: email, password: password, profile: profile)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Helper Views

struct SimpleTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct SimpleSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.primary)
            
            SecureField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct SimplePicker<T: Identifiable & Equatable>: View {
    let title: String
    @Binding var selection: T?
    let options: [T]
    let displayText: (T) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.primary)
            
            Menu {
                ForEach(options, id: \.id) { option in
                    Button(displayText(option)) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.map(displayText) ?? "Selectează \(title.lowercased())")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(selection != nil ? .primary : .secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(ProfileStore.shared)
}