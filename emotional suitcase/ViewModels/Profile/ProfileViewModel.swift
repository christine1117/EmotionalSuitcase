import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var profileData: ProfileData = .default
    private var cancellables = Set<AnyCancellable>()
    private let profileService: ProfileService
    
    init(profileService: ProfileService = .shared) {
        self.profileService = profileService
        profileService.$profileData
            .assign(to: &$profileData)
    }
    
    func updateProfile(_ data: ProfileData) {
        profileService.updateProfile(data)
    }
    
    // 可擴充 async/await 版本
    func fetchProfile() async throws {
        let data = try await profileService.fetchProfile()
        DispatchQueue.main.async {
            self.profileData = data
        }
    }
} 