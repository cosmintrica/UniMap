import Foundation

struct DatabaseUserProfile: Codable, Identifiable {
    let id: UUID
    let email: String
    let fullName: String?
    let avatarUrl: String?
    
    // Informații educaționale
    let universityId: UUID?
    let facultyId: UUID?
    let specializationId: UUID?
    let masterId: UUID?
    let studyYear: Int?
    
    // Informații personale
    let phone: String?
    let birthDate: Date?
    let bio: String?
    
    // Preferințe
    let preferredLanguage: String
    let notificationsEnabled: Bool
    
    // Admin status
    let isAdmin: Bool
    
    // Metadate
    let isActive: Bool
    let lastLogin: Date?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case universityId = "university_id"
        case facultyId = "faculty_id"
        case specializationId = "specialization_id"
        case masterId = "master_id"
        case studyYear = "study_year"
        case phone
        case birthDate = "birth_date"
        case bio
        case preferredLanguage = "preferred_language"
        case notificationsEnabled = "notifications_enabled"
        case isAdmin = "is_admin"
        case isActive = "is_active"
        case lastLogin = "last_login"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
