//
//  ProfileStore.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import Foundation
import Combine

// MARK: - Tipuri
enum StudyYear: String, CaseIterable, Codable {
    case i = "1", ii = "2", iii = "3", iv = "4", v = "5", vi = "6"
    var displayName: String { "Anul \(rawValue)" }
}

struct StudentProfile: Codable, Identifiable, Equatable {
    let id: String
    var city: String
    var university: String
    var faculty: String
    var specialization: String?
    var year: StudyYear
    var email: String?

    var displayName: String {
        if let e = email, let name = e.split(separator: "@").first { return String(name) }
        return "Student UniMap"
    }
}

// MARK: - Store
final class ProfileStore: ObservableObject {
    static let shared = ProfileStore()
    private init() { self.profile = Self.load() }

    @Published var profile: StudentProfile?

    // ⚠️ PUNE AICI ADRESA TA DE EMAIL (lowercase)
    private let adminEmails: Set<String> = ["cosmin.trica@outlook.com"]

    var isCurrentUserAdmin: Bool {
        guard let mail = profile?.email?.lowercased(), !mail.isEmpty else { return false }
        return adminEmails.contains(mail)
    }

    // Persis­tență simplă (fără extensii externe)
    private static let storeKey = "unimap_student_profile_v1"

    private static func load() -> StudentProfile? {
        guard let data = UserDefaults.standard.data(forKey: storeKey) else { return nil }
        return try? JSONDecoder().decode(StudentProfile.self, from: data)
    }

    private func saveToDisk(_ p: StudentProfile?) {
        if let p, let data = try? JSONEncoder().encode(p) {
            UserDefaults.standard.set(data, forKey: Self.storeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Self.storeKey)
        }
    }

    // API public
    func save(_ p: StudentProfile) {
        saveToDisk(p)
        profile = p
    }
    func clear() {
        saveToDisk(nil)
        profile = nil
    }
}
