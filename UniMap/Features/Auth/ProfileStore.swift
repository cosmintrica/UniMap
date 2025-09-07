//
//  ProfileStore.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//

import Foundation
import Combine
import Supabase

// MARK: - Tipuri
enum StudyYear: String, CaseIterable, Codable {
    case i = "1", ii = "2", iii = "3", iv = "4", v = "5", vi = "6"
    var displayName: String { "Anul \(rawValue)" }
    
    var intValue: Int {
        return Int(rawValue) ?? 1
    }
    
    init(intValue: Int) {
        self = StudyYear(rawValue: String(intValue)) ?? .i
    }
}

// MARK: - Structuri pentru profil complet
struct CompleteUserProfile: Codable, Identifiable, Equatable {
    let id: String
    let email: String
    let fullName: String?
    let avatarUrl: String?
    
    // Informații educaționale
    let university: University?
    let faculty: Faculty?
    let specialization: Specialization?
    let master: Master?
    let studyYear: StudyYear?
    
    // Informații personale
    let phone: String?
    let birthDate: Date?
    let bio: String?
    
    // Preferințe
    let preferredLanguage: String
    let notificationsEnabled: Bool
    
    var displayName: String {
        if let fullName = fullName, !fullName.isEmpty {
            return fullName
        }
        if let name = email.split(separator: "@").first {
            return String(name)
        }
        return "Student UniMap"
    }
    
    var educationalInfo: String {
        var parts: [String] = []
        
        if let university = university {
            parts.append(university.name)
        }
        if let faculty = faculty {
            parts.append(faculty.name)
        }
        if let specialization = specialization {
            parts.append(specialization.name)
        }
        if let year = studyYear {
            parts.append("Anul \(year.rawValue)")
        }
        
        return parts.joined(separator: " • ")
    }
}

// MARK: - Struct pentru actualizare profil
struct ProfileUpdate: Codable {
    let fullName: String?
    let phone: String?
    let birthDate: Date?
    let bio: String?
    let universityId: UUID?
    let facultyId: UUID?
    let specializationId: UUID?
    let masterId: UUID?
    let studyYear: Int?
    let preferredLanguage: String?
    let notificationsEnabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case phone
        case birthDate = "birth_date"
        case bio
        case universityId = "university_id"
        case facultyId = "faculty_id"
        case specializationId = "specialization_id"
        case masterId = "master_id"
        case studyYear = "study_year"
        case preferredLanguage = "preferred_language"
        case notificationsEnabled = "notifications_enabled"
    }
}

// MARK: - Store
final class ProfileStore: ObservableObject {
    static let shared = ProfileStore()
    private init() { 
        self.profile = Self.load()
        self.supabase = SupabaseManager.shared
        // Nu încărca datele educaționale în init() pentru a evita probleme de runtime
    }

    @Published var profile: CompleteUserProfile?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Cache pentru date educaționale
    @Published var universities: [University] = []
    @Published var faculties: [Faculty] = []
    @Published var specializations: [Specialization] = []
    @Published var masters: [Master] = []
    
    private let supabase: SupabaseManager

    // ⚠️ PUNE AICI ADRESA TA DE EMAIL (lowercase)
    private let adminEmails: Set<String> = ["cosmin.trica@outlook.com"]

    var isCurrentUserAdmin: Bool {
        guard let mail = profile?.email.lowercased(), !mail.isEmpty else { return false }
        return adminEmails.contains(mail)
    }

    // Persis­tență simplă (fără extensii externe)
    private static let storeKey = "unimap_complete_profile_v2"

    private static func load() -> CompleteUserProfile? {
        guard let data = UserDefaults.standard.data(forKey: storeKey) else { return nil }
        return try? JSONDecoder().decode(CompleteUserProfile.self, from: data)
    }

    private func saveToDisk(_ p: CompleteUserProfile?) {
        if let p, let data = try? JSONEncoder().encode(p) {
            UserDefaults.standard.set(data, forKey: Self.storeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Self.storeKey)
        }
    }

    // MARK: - Authentication
    func signUp(email: String, password: String, profile: CompleteUserProfile) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let session = try await supabase.signUp(email: email, password: password)
            let user = session.user
            
            // Creează profilul în baza de date
            let userProfile = DatabaseUserProfile(
                id: user.id,
                email: user.email ?? email,
                fullName: profile.fullName,
                avatarUrl: profile.avatarUrl,
                universityId: profile.university?.id,
                facultyId: profile.faculty?.id,
                specializationId: profile.specialization?.id,
                masterId: profile.master?.id,
                studyYear: profile.studyYear?.intValue,
                phone: profile.phone,
                birthDate: profile.birthDate,
                bio: profile.bio,
                preferredLanguage: profile.preferredLanguage,
                notificationsEnabled: profile.notificationsEnabled,
                isActive: true,
                lastLogin: Date(),
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // Inserează profilul în baza de date
            try await supabase.client
                .from("user_profiles")
                .insert(userProfile)
                .execute()
            
            // Folosește profilul primit ca parametru, doar cu ID-ul actualizat
            await MainActor.run {
                self.profile = CompleteUserProfile(
                    id: user.id.uuidString,
                    email: user.email ?? email,
                    fullName: profile.fullName,
                    avatarUrl: profile.avatarUrl,
                    university: profile.university,
                    faculty: profile.faculty,
                    specialization: profile.specialization,
                    master: profile.master,
                    studyYear: profile.studyYear,
                    phone: profile.phone,
                    birthDate: profile.birthDate,
                    bio: profile.bio,
                    preferredLanguage: profile.preferredLanguage,
                    notificationsEnabled: profile.notificationsEnabled
                )
                self.isAuthenticated = true
                self.saveToDisk(self.profile)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let session = try await supabase.signIn(email: email, password: password)
            let user = session.user
            // Încarcă profilul existent sau creează unul nou
            var existingProfile = Self.load()
            if existingProfile == nil {
                existingProfile = CompleteUserProfile(
                    id: user.id.uuidString,
                    email: user.email ?? email,
                    fullName: nil,
                    avatarUrl: nil,
                    university: nil,
                    faculty: nil,
                    specialization: nil,
                    master: nil,
                    studyYear: nil,
                    phone: nil,
                    birthDate: nil,
                    bio: nil,
                    preferredLanguage: "ro",
                    notificationsEnabled: true
                )
            }
            
            let finalProfile = existingProfile!
            await MainActor.run {
                self.profile = finalProfile
                self.isAuthenticated = true
                self.saveToDisk(finalProfile)
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    func signOut() async {
        do {
            try await supabase.signOut()
            await MainActor.run {
                self.profile = nil
                self.isAuthenticated = false
                self.clear()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func checkAuthenticationStatus() {
        if let user = supabase.getCurrentUser() {
            isAuthenticated = true
            if profile == nil {
                profile = CompleteUserProfile(
                    id: user.id.uuidString,
                    email: user.email ?? "",
                    fullName: nil,
                    avatarUrl: nil,
                    university: nil,
                    faculty: nil,
                    specialization: nil,
                    master: nil,
                    studyYear: nil,
                    phone: nil,
                    birthDate: nil,
                    bio: nil,
                    preferredLanguage: "ro",
                    notificationsEnabled: true
                )
            }
        } else {
            isAuthenticated = false
        }
    }

    // MARK: - Data Loading
    func loadEducationalDataIfNeeded() async {
        // Încarcă doar dacă nu sunt deja încărcate
        if universities.isEmpty {
            await loadEducationalData()
        }
    }
    
    func loadEducationalData() async {
        await loadUniversities()
        await loadFaculties()
        await loadSpecializations()
        await loadMasters()
    }
    
    private func loadUniversities() async {
        do {
            let universities: [University] = try await supabase.client
                .from("universities")
                .select()
                .eq("is_active", value: true)
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.universities = universities
            }
        } catch {
            print("Error loading universities: \(error)")
        }
    }
    
    private func loadFaculties() async {
        do {
            let faculties: [Faculty] = try await supabase.client
                .from("faculties")
                .select()
                .eq("is_active", value: true)
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.faculties = faculties
            }
        } catch {
            print("Error loading faculties: \(error)")
        }
    }
    
    private func loadSpecializations() async {
        do {
            let specializations: [Specialization] = try await supabase.client
                .from("specializations")
                .select()
                .eq("is_active", value: true)
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.specializations = specializations
            }
        } catch {
            print("Error loading specializations: \(error)")
        }
    }
    
    private func loadMasters() async {
        do {
            let masters: [Master] = try await supabase.client
                .from("masters")
                .select()
                .eq("is_active", value: true)
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.masters = masters
            }
        } catch {
            print("Error loading masters: \(error)")
        }
    }
    
    // MARK: - Profile Management
    func updateProfile(_ update: ProfileUpdate) async {
        guard let userId = profile?.id else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Actualizează în baza de date
            try await supabase.client
                .from("user_profiles")
                .update(update)
                .eq("id", value: userId)
                .execute()
            
            // Reîncarcă profilul complet
            await loadCompleteProfile()
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    private func loadCompleteProfile() async {
        guard let userId = profile?.id else { return }
        
        do {
            // Încarcă profilul cu relațiile
            let response: [DatabaseUserProfile] = try await supabase.client
                .from("user_profiles")
                .select("""
                    *,
                    universities:university_id(*),
                    faculties:faculty_id(*),
                    specializations:specialization_id(*),
                    masters:master_id(*)
                """)
                .eq("id", value: userId)
                .execute()
                .value
            
            guard let userProfile = response.first else { return }
            
            // Construiește profilul complet
            let completeProfile = CompleteUserProfile(
                id: userProfile.id.uuidString,
                email: userProfile.email,
                fullName: userProfile.fullName,
                avatarUrl: userProfile.avatarUrl,
                university: nil, // TODO: Parse from response
                faculty: nil,    // TODO: Parse from response
                specialization: nil, // TODO: Parse from response
                master: nil,     // TODO: Parse from response
                studyYear: userProfile.studyYear.map { StudyYear(intValue: $0) },
                phone: userProfile.phone,
                birthDate: userProfile.birthDate,
                bio: userProfile.bio,
                preferredLanguage: userProfile.preferredLanguage,
                notificationsEnabled: userProfile.notificationsEnabled
            )
            
            await MainActor.run {
                self.profile = completeProfile
                self.saveToDisk(completeProfile)
            }
            
        } catch {
            print("Error loading complete profile: \(error)")
        }
    }

    // API public
    func save(_ p: CompleteUserProfile) {
        saveToDisk(p)
        profile = p
    }

    func clear() {
        saveToDisk(nil)
        profile = nil
        isAuthenticated = false
    }
}
