import Foundation

struct MapFile: Codable, Identifiable {
    let id: UUID
    let buildingId: UUID
    let fileName: String
    let filePath: String
    let fileType: String
    let fileSize: Int64?
    let version: String
    let isActive: Bool
    let uploadedBy: UUID?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case buildingId = "building_id"
        case fileName = "file_name"
        case filePath = "file_path"
        case fileType = "file_type"
        case fileSize = "file_size"
        case version
        case isActive = "is_active"
        case uploadedBy = "uploaded_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
