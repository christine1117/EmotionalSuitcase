import Foundation
import Combine

final class RelaxationViewModel: ObservableObject {
    @Published var relaxationTips: [RelaxationTip] = []
    @Published var timerManager = TimerManager()
    @Published var breathingManager = BreathingManager()
    @Published var hrvManager = HRVManager()
    private var cancellables = Set<AnyCancellable>()
    private let relaxationService: RelaxationService
    
    init(relaxationService: RelaxationService = .shared) {
        self.relaxationService = relaxationService
        relaxationService.$relaxationTips
            .assign(to: &$relaxationTips)
    }
    
    func refresh() {
        relaxationService.loadSampleTips()
    }
    
    func fetchRelaxationTips() async throws {
        let tips = try await relaxationService.fetchRelaxationTips()
        DispatchQueue.main.async {
            self.relaxationTips = tips
        }
    }
} 