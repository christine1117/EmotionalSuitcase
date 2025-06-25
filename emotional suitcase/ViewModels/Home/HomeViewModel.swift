import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var biorhythmData: [Biorhythm] = []
    private var cancellables = Set<AnyCancellable>()
    private let homeService: HomeService
    
    init(homeService: HomeService = .shared) {
        self.homeService = homeService
        homeService.$biorhythmData
            .assign(to: &$biorhythmData)
    }
    
    func refresh() {
        homeService.loadSampleData()
    }
    
    // 可擴充 async/await 版本
    func fetchBiorhythmData() async throws {
        let data = try await homeService.fetchBiorhythmData()
        DispatchQueue.main.async {
            self.biorhythmData = data
        }
    }
} 