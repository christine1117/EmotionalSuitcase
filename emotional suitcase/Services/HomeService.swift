import Foundation
import Combine

final class HomeService: ObservableObject {
    static let shared = HomeService()
    
    // 範例資料，可換成 API/DB/LLM
    @Published private(set) var biorhythmData: [Biorhythm] = []
    
    private init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        // TODO: 換成 API/DB/LLM
        biorhythmData = [
            Biorhythm(date: Date(), value: 0.8),
            Biorhythm(date: Date().addingTimeInterval(-86400), value: 0.6)
        ]
    }
    
    // 可擴充 async/await 版本
    func fetchBiorhythmData() async throws -> [Biorhythm] {
        // TODO: 串接 API/DB/LLM
        return biorhythmData
    }
}

struct Biorhythm: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let value: Double
} 