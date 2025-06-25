import Foundation
import SwiftUI

// MARK: - 放鬆模式
enum RelaxationMode: String, CaseIterable, Codable {
    case breathing = "breathing"
    case meditation = "meditation"
}

// MARK: - 計時器狀態
enum TimerState: Codable {
    case stopped
    case running
    case paused
    case completed
}

// MARK: - 呼吸階段
enum BreathingPhase: String, CaseIterable, Codable {
    case inhale = "inhale"
    case hold = "hold"
    case exhale = "exhale"
    case pause = "pause"
}

extension BreathingPhase {
    var color: Color {
        switch self {
        case .inhale:
            return AppColors.orange
        case .hold:
            return AppColors.yellowMain
        case .exhale:
            return AppColors.brownDeep
        case .pause:
            return AppColors.grayLight
        }
    }
}

// MARK: - 呼吸模式配置
struct BreathingPattern: Codable {
    let name: String
    let inhaleSeconds: Double
    let holdSeconds: Double
    let exhaleSeconds: Double
    let pauseSeconds: Double
    let description: String
}

// MARK: - 放鬆提示
struct RelaxationTip: Codable {
    let title: String
    let content: String
    let mode: RelaxationMode
    let timeRange: ClosedRange<Int>
    
    private enum CodingKeys: String, CodingKey {
        case title, content, mode, timeRangeStart, timeRangeEnd
    }
    
    init(title: String, content: String, mode: RelaxationMode, timeRange: ClosedRange<Int>) {
        self.title = title
        self.content = content
        self.mode = mode
        self.timeRange = timeRange
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        mode = try container.decode(RelaxationMode.self, forKey: .mode)
        let start = try container.decode(Int.self, forKey: .timeRangeStart)
        let end = try container.decode(Int.self, forKey: .timeRangeEnd)
        timeRange = start...end
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(mode, forKey: .mode)
        try container.encode(timeRange.lowerBound, forKey: .timeRangeStart)
        try container.encode(timeRange.upperBound, forKey: .timeRangeEnd)
    }
}

// MARK: - HRV 數據點
struct HRVDataPoint: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let value: Double
    let quality: HRVQuality
    
    init(id: UUID = UUID(), timestamp: Date = Date(), value: Double, quality: HRVQuality) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
        self.quality = quality
    }
    
    enum HRVQuality: String, Codable {
        case poor = "poor"
        case fair = "fair"
        case good = "good"
        case excellent = "excellent"
    }
}

// MARK: - 放鬆會話紀錄
struct RelaxationSession: Identifiable, Codable {
    let id: UUID
    let mode: RelaxationMode
    let startTime: Date
    let endTime: Date
    let notes: String
    
    init(id: UUID = UUID(), mode: RelaxationMode, startTime: Date, endTime: Date, notes: String = "") {
        self.id = id
        self.mode = mode
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
    }
}
