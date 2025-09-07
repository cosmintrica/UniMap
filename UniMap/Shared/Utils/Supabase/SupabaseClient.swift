import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    private var _client: SupabaseClient?
    
    var client: SupabaseClient {
        if let client = _client {
            return client
        }
        
        // Lazy initialization - doar când este nevoie
        guard let configPath = Bundle.main.path(forResource: "supabase-config", ofType: "plist"),
              let configData = NSDictionary(contentsOfFile: configPath),
              let urlString = configData["SupabaseURL"] as? String,
              let supabaseURL = URL(string: urlString),
              let supabaseKey = configData["SupabaseAnonKey"] as? String else {
            fatalError("Nu s-a putut încărca configurația Supabase din supabase-config.plist")
        }
        
        let newClient = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
        
        _client = newClient
        return newClient
    }
    
    private init() {
        // Nu inițializăm client-ul aici - doar când este nevoie
    }
}

// MARK: - Authentication
extension SupabaseManager {
    func signUp(email: String, password: String) async throws -> Session {
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        // Returnează session temporar chiar dacă email-ul nu este verificat
        // Utilizatorii pot verifica email-ul mai târziu
        if let session = response.session {
            return session
        } else {
            // Creează session temporar pentru email neverificat
            let user = response.user
            let tempSession = Session(
                providerToken: nil,
                providerRefreshToken: nil,
                accessToken: "temp_token",
                tokenType: "bearer",
                expiresIn: 3600,
                expiresAt: Date().addingTimeInterval(3600).timeIntervalSince1970,
                refreshToken: "temp_refresh",
                weakPassword: nil,
                user: user
            )
            return tempSession
        }
    }
    
    func signIn(email: String, password: String) async throws -> Session {
        return try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() -> Auth.User? {
        return client.auth.currentUser
    }
}
