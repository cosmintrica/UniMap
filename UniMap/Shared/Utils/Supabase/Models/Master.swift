import Foundation

struct Master: Codable, Identifiable, Hashable {
    let id: UUID
    let facultyId: UUID
    let specializationId: UUID?
    let name: String
    let code: String?
    let durationYears: Int
    let description: String?
    let requirements: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case facultyId = "faculty_id"
        case specializationId = "specialization_id"
        case name
        case code
        case durationYears = "duration_years"
        case description
        case requirements
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
