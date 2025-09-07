import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Încarcă configurația din plist
        guard let configPath = Bundle.main.path(forResource: "supabase-config", ofType: "plist"),
              let configData = NSDictionary(contentsOfFile: configPath),
              let urlString = configData["SupabaseURL"] as? String,
              let supabaseURL = URL(string: urlString),
              let supabaseKey = configData["SupabaseAnonKey"] as? String else {
            fatalError("Nu s-a putut încărca configurația Supabase din supabase-config.plist")
        }
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}

// MARK: - Authentication
extension SupabaseManager {
    func signUp(email: String, password: String) async throws -> Session {
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        guard let session = response.session else {
            throw NSError(domain: "SupabaseAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create session"])
        }
        return session
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
