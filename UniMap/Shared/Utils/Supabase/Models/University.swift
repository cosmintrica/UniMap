import Foundation

struct University: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let city: String
    let country: String
    let website: String?
    let logoUrl: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case city
        case country
        case website
        case logoUrl = "logo_url"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
