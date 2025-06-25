import Foundation
import Combine

final class TrackingViewModel: ObservableObject {
    @Published var moodEntries: [MoodEntry] = []
    @Published var scaleRecords: [ScaleRecord] = []
    @Published var healthMetrics: [HealthMetric] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let trackingService: TrackingService
    
    init(trackingService: TrackingService = .shared) {
        self.trackingService = trackingService
        trackingService.$moodEntries.assign(to: &$moodEntries)
        trackingService.$scaleRecords.assign(to: &$scaleRecords)
        trackingService.$healthMetrics.assign(to: &$healthMetrics)
    }
    
    // MARK: - Mood
    func addMoodEntry(_ mood: String, note: String? = nil, date: Date = Date()) {
        trackingService.addMoodEntry(mood, note: note, date: date)
    }
    
    func getMoodEntry(for date: Date) -> MoodEntry? {
        moodEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getCurrentMonthEntries(selectedMonth: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedMonth)
        let year = calendar.component(.year, from: selectedMonth)
        return moodEntries.filter { entry in
            let entryMonth = calendar.component(.month, from: entry.date)
            let entryYear = calendar.component(.year, from: entry.date)
            return entryMonth == month && entryYear == year
        }
    }
    
    // MARK: - Scale
    func getLastRecord(for scale: ScaleType) -> ScaleRecord? {
        scaleRecords.filter { $0.type == scale }.sorted { $0.date > $1.date }.first
    }
    
    func getRecords(for scale: ScaleType) -> [ScaleRecord] {
        scaleRecords.filter { $0.type == scale }.sorted { $0.date > $1.date }
    }
    
    func addScaleRecord(_ record: ScaleRecord) {
        trackingService.addScaleRecord(record)
    }
    
    // MARK: - Health
    func getHealthMetric(type: HealthMetricType) -> HealthMetric? {
        healthMetrics.first { $0.type == type }
    }
    
    func updateHealthMetric(_ metric: HealthMetric) {
        trackingService.updateHealthMetric(metric)
    }
    
    // MARK: - 分析/統計
    func analyzeCommonWords(selectedMonth: Date) -> [(String, Int)] {
        let entries = getCurrentMonthEntries(selectedMonth: selectedMonth)
        let allText = entries.map { $0.mood }.joined(separator: " ")
        let words = allText.split(separator: " ").map(String.init)
        let wordCounts = words.reduce(into: [String: Int]()) { counts, word in
            counts[word, default: 0] += 1
        }
        return Array(wordCounts.sorted { $0.value > $1.value }.prefix(10))
    }
    
    // MARK: - 統計、資料過濾、建議產生
    // TODO: 將所有統計、資料過濾、建議產生等邏輯集中於本 ViewModel，供 Tracking 相關 View 使用。
    
    // MARK: - Refresh
    func refreshAll() {
        trackingService.loadSampleEntries()
        trackingService.loadSampleScaleRecords()
        trackingService.loadSampleHealthMetrics()
    }
} 