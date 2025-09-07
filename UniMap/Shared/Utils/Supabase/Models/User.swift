import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let fullName: String?
    let avatarURL: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserProfile: Codable {
    let id: UUID
    let email: String
    let fullName: String?
    let avatarURL: String?
    let university: String?
    let studentId: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case avatarURL = "avatar_url"
        case university
        case studentId = "student_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
