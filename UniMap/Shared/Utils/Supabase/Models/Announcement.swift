import Foundation

struct Announcement: Codable, Identifiable {
    let id: UUID
    let title: String
    let content: String
    let imageURL: String?
    let priority: AnnouncementPriority
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    let expiresAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case imageURL = "image_url"
        case priority
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case expiresAt = "expires_at"
    }
}

enum AnnouncementPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
    
    var displayName: String {
        switch self {
        case .low: return "Scăzut"
        case .medium: return "Mediu"
        case .high: return "Ridicat"
        case .urgent: return "Urgent"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}
