import Foundation

struct Faculty: Codable, Identifiable, Hashable {
    let id: UUID
    let universityId: UUID
    let name: String
    let code: String?
    let description: String?
    let website: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case universityId = "university_id"
        case name
        case code
        case description
        case website
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
