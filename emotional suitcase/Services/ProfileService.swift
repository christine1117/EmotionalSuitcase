import Foundation
import Combine

final class ProfileService: ObservableObject {
    static let shared = ProfileService()
    
    @Published private(set) var profileData: ProfileData = ProfileData.default
    
    private init() {
        // 可在此載入本地或 API 資料
    }
    
    func updateProfile(_ data: ProfileData) {
        profileData = data
        // TODO: 可加上 API/DB 寫入
    }
    
    // 可擴充 async/await 版本
    func fetchProfile() async throws -> ProfileData {
        // TODO: 串接 API/DB/LLM
        return profileData
    }
} 