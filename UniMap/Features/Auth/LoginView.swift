import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileStore: ProfileStore
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var showRegistration = false
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 16) {
                            Text("Bun venit înapoi")
                                .font(.system(size: 32, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            
                            Text("Conectează-te pentru a continua")
                                .font(.system(size: 17, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 60)
                        .padding(.horizontal, 32)
                        
                        Spacer()
                        
                        // Form
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                SimpleTextField(
                                    title: "Email",
                                    text: $email,
                                    placeholder: "nume@exemplu.com"
                                )
                                .focused($focusedField, equals: .email)
                                
                                SimpleSecureField(
                                    title: "Parolă",
                                    text: $password,
                                    placeholder: "Introdu parola"
                                )
                                .focused($focusedField, equals: .password)
                            }
                            
                            // Login button
                            Button(action: signIn) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    }
                                    Text("Conectează-te")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(canSignIn ? Color.accentColor : Color.accentColor.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(!canSignIn || isLoading)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer()
                        
                        // Footer
                        VStack(spacing: 16) {
                            Button("Ai uitat parola?") {
                                // TODO: Implement forgot password
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Text("Nu ai cont?")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                Button("Înregistrează-te") {
                                    showRegistration = true
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 50))
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Eroare", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showRegistration) {
            RegistrationView()
        }
    }
    
    private var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    private func signIn() {
        guard canSignIn else { return }
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                await profileStore.signIn(email: email, password: password)
                dismiss()
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

// MARK: - Helper Views referenced from RegistrationView

#Preview {
    LoginView()
        .environmentObject(ProfileStore.shared)
}
