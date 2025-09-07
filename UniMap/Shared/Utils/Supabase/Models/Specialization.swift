import Foundation

struct Specialization: Codable, Identifiable, Hashable {
    let id: UUID
    let facultyId: UUID
    let name: String
    let code: String
    let durationYears: Int
    let description: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case facultyId = "faculty_id"
        case name
        case code
        case durationYears = "duration_years"
        case description
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
