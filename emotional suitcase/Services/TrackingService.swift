import Foundation
import Combine

final class TrackingService: ObservableObject {
    static let shared = TrackingService()
    
    @Published private(set) var moodEntries: [MoodEntry] = []
    @Published private(set) var scaleRecords: [ScaleRecord] = []
    @Published private(set) var healthMetrics: [HealthMetric] = []
    
    private init() {
        loadSampleEntries()
        loadSampleScaleRecords()
        loadSampleHealthMetrics()
    }
    
    func loadSampleEntries() {
        moodEntries = [
            MoodEntry(date: Date(), mood: "開心"),
            MoodEntry(date: Date().addingTimeInterval(-86400), mood: "平靜")
        ]
    }
    
    func loadSampleScaleRecords() {
        scaleRecords = [
            ScaleRecord(type: .phq9, score: 12, answers: [2,2,2,2,2,1,1,1,1], date: Date()),
            ScaleRecord(type: .gad7, score: 8, answers: [1,1,1,1,1,1,1], date: Date().addingTimeInterval(-86400*3)),
            ScaleRecord(type: .bsrs5, score: 6, answers: [1,1,1,1,2], date: Date().addingTimeInterval(-86400*7))
        ]
    }
    
    func loadSampleHealthMetrics() {
        healthMetrics = [
            HealthMetric(type: .heartRateVariability, value: 48, trend: 2.3),
            HealthMetric(type: .sleepQuality, value: 2.4, trend: -1.2),
            HealthMetric(type: .activityLevel, value: 7200, trend: 5.7),
            HealthMetric(type: .weight, value: 53.2)
        ]
    }
    
    func fetchMoodEntries() async throws -> [MoodEntry] {
        // TODO: 串接 API/DB/LLM
        return moodEntries
    }
    
    func fetchScaleRecords() async throws -> [ScaleRecord] {
        return scaleRecords
    }
    
    func fetchHealthMetrics() async throws -> [HealthMetric] {
        return healthMetrics
    }
    
    func addMoodEntry(_ mood: String, note: String? = nil, date: Date = Date()) {
        let entry = MoodEntry(date: date, mood: mood)
        moodEntries.append(entry)
    }
    
    func addScaleRecord(_ record: ScaleRecord) {
        scaleRecords.append(record)
    }
    
    func updateHealthMetric(_ metric: HealthMetric) {
        if let idx = healthMetrics.firstIndex(where: { $0.type == metric.type }) {
            healthMetrics[idx] = metric
        } else {
            healthMetrics.append(metric)
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let mood: String
}

struct ScaleRecord: Identifiable, Codable {
    let id = UUID()
    let type: ScaleType
    let score: Int
    let answers: [Int]
    let date: Date
}

struct HealthMetric: Identifiable, Codable {
    let id = UUID()
    let type: HealthMetricType
    let value: Double
    let trend: Double
} 