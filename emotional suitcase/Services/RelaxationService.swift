import Foundation
import Combine

final class RelaxationService: ObservableObject {
    static let shared = RelaxationService()
    
    @Published private(set) var relaxationTips: [RelaxationTip] = []
    
    private init() {
        loadSampleTips()
    }
    
    func loadSampleTips() {
        relaxationTips = [
            RelaxationTip(title: "深呼吸", description: "慢慢吸氣，慢慢吐氣，重複5次。"),
            RelaxationTip(title: "正念觀察", description: "觀察當下的感受，不做評價。")
        ]
    }
    
    func fetchRelaxationTips() async throws -> [RelaxationTip] {
        // TODO: 串接 API/DB/LLM
        return relaxationTips
    }
}

struct RelaxationTip: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
}

// MARK: - 計時器管理
class TimerManager: ObservableObject {
    // ...（原 TimeBreathManager.swift 內容，已搬移）...
}

// MARK: - 呼吸管理
class BreathingManager: ObservableObject {
    // ...（原 TimeBreathManager.swift 內容，已搬移）...
}

// MARK: - HRV 數據管理
class HRVManager: ObservableObject {
    // ...（原 HRVManager.swift 內容，已搬移）...
} 