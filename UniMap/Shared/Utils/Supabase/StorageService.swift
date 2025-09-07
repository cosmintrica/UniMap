import Foundation
import Supabase

class StorageService: ObservableObject {
    static let shared = StorageService()
    
    private let supabase = SupabaseManager.shared
    
    private init() {}
    
    // MARK: - Map Files Management
    
    /// Upload un fișier de hartă la Supabase Storage
    func uploadMapFile(
        buildingId: UUID,
        fileName: String,
        fileData: Data,
        fileType: String
    ) async throws -> MapFile {
        
        let filePath = "maps/\(buildingId)/\(fileName)"
        
        // Upload la Supabase Storage
        try await supabase.client.storage
            .from("map-files")
            .upload(filePath, data: fileData)
        
        // Creează înregistrarea în baza de date
        let mapFile = MapFile(
            id: UUID(),
            buildingId: buildingId,
            fileName: fileName,
            filePath: filePath,
            fileType: fileType,
            fileSize: Int64(fileData.count),
            version: "1.0",
            isActive: true,
            uploadedBy: supabase.getCurrentUser()?.id,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let insertedFile: MapFile = try await supabase.client
            .from("map_files")
            .insert(mapFile)
            .select()
            .single()
            .execute()
            .value
        
        return insertedFile
    }
    
    /// Download un fișier de hartă din Supabase Storage
    func downloadMapFile(filePath: String) async throws -> Data {
        return try await supabase.client.storage
            .from("map-files")
            .download(path: filePath)
    }
    
    /// Obține lista de fișiere pentru o clădire
    func getMapFiles(for buildingId: UUID) async throws -> [MapFile] {
        return try await supabase.client
            .from("map_files")
            .select()
            .eq("building_id", value: buildingId)
            .eq("is_active", value: true)
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    /// Șterge un fișier de hartă
    func deleteMapFile(_ fileId: UUID) async throws {
        // Obține informațiile despre fișier
        let file: MapFile = try await supabase.client
            .from("map_files")
            .select()
            .eq("id", value: fileId)
            .single()
            .execute()
            .value
        
        // Șterge din Storage
        try await supabase.client.storage
            .from("map-files")
            .remove(paths: [file.filePath])
        
        // Marchează ca inactiv în baza de date
        try await supabase.client
            .from("map_files")
            .update(["is_active": false])
            .eq("id", value: fileId)
            .execute()
        
        try await supabase.client
            .from("map_files")
            .update(["updated_at": "\(Date().ISO8601Format())"])
            .eq("id", value: fileId)
            .execute()
    }
    
    // MARK: - Image Upload
    
    /// Upload o imagine (avatar, logo, etc.)
    func uploadImage(
        folder: String,
        fileName: String,
        imageData: Data
    ) async throws -> String {
        let filePath = "\(folder)/\(fileName)"
        
        try await supabase.client.storage
            .from("images")
            .upload(filePath, data: imageData)
        
        // Returnează URL-ul public
        return try supabase.client.storage
            .from("images")
            .getPublicURL(path: filePath).absoluteString
    }
    
    /// Upload avatar utilizator
    func uploadUserAvatar(userId: UUID, imageData: Data) async throws -> String {
        let fileName = "\(userId.uuidString).jpg"
        return try await uploadImage(folder: "avatars", fileName: fileName, imageData: imageData)
    }
    
    /// Upload logo universitate
    func uploadUniversityLogo(universityId: UUID, imageData: Data) async throws -> String {
        let fileName = "\(universityId.uuidString).png"
        return try await uploadImage(folder: "university-logos", fileName: fileName, imageData: imageData)
    }
    
    // MARK: - JSON Map Files
    
    /// Upload un fișier JSON de hartă
    func uploadMapJSON(
        buildingId: UUID,
        mapData: [String: Any],
        fileName: String? = nil
    ) async throws -> MapFile {
        
        // Convertește la JSON
        let jsonData = try JSONSerialization.data(withJSONObject: mapData, options: .prettyPrinted)
        
        // Generează numele fișierului dacă nu este specificat
        let finalFileName = fileName ?? "map_\(Date().timeIntervalSince1970).json"
        
        return try await uploadMapFile(
            buildingId: buildingId,
            fileName: finalFileName,
            fileData: jsonData,
            fileType: "json"
        )
    }
    
    /// Download și parsează un fișier JSON de hartă
    func downloadMapJSON(filePath: String) async throws -> [String: Any] {
        let data = try await downloadMapFile(filePath: filePath)
        return try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
    }
}
