import Foundation
import Combine
import SwiftUI

final class DailyCheckInViewModel: ObservableObject {
    @Published var currentQuestion: Int = 0
    @Published var answers: [Int] = Array(repeating: -1, count: 5)
    @Published var showingResult: Bool = false
    @Published var isFirstQuestion: Bool = true
    
    let questions: [DailyCheckInQuestion] = [
        DailyCheckInQuestion(
            title: "你今天的身體感覺如何？",
            subtitle: "評估你的整體身體健康狀況",
            category: .physical
        ),
        DailyCheckInQuestion(
            title: "你今天的精神狀態如何？",
            subtitle: "評估你的專注力和清晰度",
            category: .mental
        ),
        DailyCheckInQuestion(
            title: "你今天的心情如何？",
            subtitle: "評估你的情緒穩定性",
            category: .emotional
        ),
        DailyCheckInQuestion(
            title: "你昨晚的睡眠品質如何？",
            subtitle: "評估你的睡眠品質和充足度",
            category: .sleep
        ),
        DailyCheckInQuestion(
            title: "你今天的食慾如何？",
            subtitle: "評估你的壓力狀態",
            category: .appetite
        )
    ]
    
    let moodOptions: [MoodOption] = [
        MoodOption(emoji: "😰", label: "很差", value: 20),
        MoodOption(emoji: "😞", label: "不好", value: 40),
        MoodOption(emoji: "😐", label: "一般", value: 60),
        MoodOption(emoji: "😊", label: "良好", value: 80),
        MoodOption(emoji: "😄", label: "極佳", value: 100)
    ]
    
    private let userDefaults = UserDefaults.standard
    private let todayScoresKey = "todayScores"
    private let weeklyScoresKey = "weeklyScores"
    
    // MARK: - 分數計算與健康狀態判斷
    @Published var scores: DailyCheckInScores = DailyCheckInScores(physical: 0, mental: 0, emotional: 0, sleep: 0, appetite: 0, date: Date())
    var overallScore: Int {
        (scores.physical + scores.mental + scores.emotional + scores.sleep + scores.appetite) / 5
    }
    var healthStatus: String {
        switch overallScore {
        case 90...100: return "極佳狀態"
        case 80...89: return "良好狀態"
        case 60...79: return "一般狀態"
        case 40...59: return "需要關注"
        default: return "需要調整"
        }
    }
    var statusColor: Color {
        switch overallScore {
        case 80...100: return .green
        case 60...79: return .orange
        default: return .red
        }
    }
    
    func selectAnswer(_ index: Int) {
        answers[currentQuestion] = index
    }
    
    func nextQuestion() {
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            showingResult = true
            let scores = getCurrentScores()
            saveDailyCheckIn(scores: scores)
        }
    }
    
    func previousQuestion() {
        if currentQuestion > 0 {
            currentQuestion -= 1
        }
    }
    
    func startCheckIn() {
        isFirstQuestion = false
        currentQuestion = 0
        answers = Array(repeating: -1, count: questions.count)
        showingResult = false
    }
    
    func calculateScores() -> [Int] {
        answers.map { $0 == -1 ? 0 : moodOptions[$0].value }
    }
    
    func saveDailyCheckIn(scores: DailyCheckInScores) {
        // 保存今日分數
        if let data = try? JSONEncoder().encode(scores) {
            userDefaults.set(data, forKey: todayScoresKey)
        }
        // 添加到週數據
        var weeklyScores: [DailyCheckInScores] = []
        if let data = userDefaults.data(forKey: weeklyScoresKey),
           let scoresArr = try? JSONDecoder().decode([DailyCheckInScores].self, from: data) {
            weeklyScores = scoresArr
        }
        // 檢查今天是否已有記錄
        let today = Calendar.current.startOfDay(for: Date())
        weeklyScores.removeAll { Calendar.current.startOfDay(for: $0.date) == today }
        weeklyScores.append(scores)
        weeklyScores.sort { $0.date > $1.date }
        if let data = try? JSONEncoder().encode(weeklyScores) {
            userDefaults.set(data, forKey: weeklyScoresKey)
        }
    }
    
    func getCurrentScores() -> DailyCheckInScores {
        let values = calculateScores()
        return DailyCheckInScores(
            physical: values[safe: 0] ?? 0,
            mental: values[safe: 1] ?? 0,
            emotional: values[safe: 2] ?? 0,
            sleep: values[safe: 3] ?? 0,
            appetite: values[safe: 4] ?? 0,
            date: Date()
        )
    }
}

// Array safe subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
} 