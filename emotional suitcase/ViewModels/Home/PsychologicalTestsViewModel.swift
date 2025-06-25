import Foundation
import Combine

final class PsychologicalTestsViewModel: ObservableObject {
    // 各量表答案
    @Published var phq9Answers: [Int] = Array(repeating: -1, count: 9)
    @Published var gad7Answers: [Int] = Array(repeating: -1, count: 7)
    @Published var bsrs5Answers: [Int] = Array(repeating: -1, count: 5)
    @Published var rfq8Answers: [Int] = Array(repeating: -1, count: 8)
    // 狀態控制
    @Published var currentStep: Int = 0
    @Published var isCompleted: Bool = false
    // 分數計算
    func calculatePHQ9Score() -> Int {
        phq9Answers.reduce(0) { $0 + max($1, 0) }
    }
    func calculateGAD7Score() -> Int {
        gad7Answers.reduce(0) { $0 + max($1, 0) }
    }
    func calculateBSRS5Score() -> Int {
        bsrs5Answers.reduce(0) { $0 + max($1, 0) }
    }
    func calculateRFQ8Score() -> Int {
        rfq8Answers.reduce(0) { $0 + max($1, 0) }
    }
    // 狀態切換
    func resetPHQ9() {
        phq9Answers = Array(repeating: -1, count: 9)
        currentStep = 0
        isCompleted = false
    }
    func resetGAD7() {
        gad7Answers = Array(repeating: -1, count: 7)
        currentStep = 0
        isCompleted = false
    }
    func resetBSRS5() {
        bsrs5Answers = Array(repeating: -1, count: 5)
        currentStep = 0
        isCompleted = false
    }
    func resetRFQ8() {
        rfq8Answers = Array(repeating: -1, count: 8)
        currentStep = 0
        isCompleted = false
    }
    // MARK: - 分數計算與建議產生
    // TODO: 將 PHQ9、BSRS5、GAD7、RFQ8 等所有分數計算、建議產生、狀態切換等邏輯集中於本 ViewModel，供各 TestView/ResultView 使用。
} 