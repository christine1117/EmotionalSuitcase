import Foundation
import Combine

final class MentalHealthResourcesViewModel: ObservableObject {
    @Published var showingHotlineSheet = false
    @Published var showingGuideSheet = false
    @Published var showingTechniquesSheet = false
    @Published var showingMapSheet = false
    
    let resources: [MentalHealthResource] = [
        MentalHealthResource(
            title: "24小時心理諮詢熱線",
            subtitle: "專業心理師即時協助",
            icon: "phone.fill",
            buttonText: "立即撥打",
            action: .hotline
        ),
        MentalHealthResource(
            title: "心理健康指南",
            subtitle: "全面了解心理健康知識",
            icon: "book.fill",
            buttonText: "查看更多",
            action: .guide
        ),
        MentalHealthResource(
            title: "情緒管理技巧",
            subtitle: "學習有效調節情緒方法",
            icon: "heart.circle.fill",
            buttonText: "查看更多",
            action: .techniques
        ),
        MentalHealthResource(
            title: "附近心理診所",
            subtitle: "尋找專業醫療協助",
            icon: "location.fill",
            buttonText: "查看地圖",
            action: .map
        )
    ]
    
    func showSheet(for action: ResourceAction) {
        switch action {
        case .hotline:
            showingHotlineSheet = true
        case .guide:
            showingGuideSheet = true
        case .techniques:
            showingTechniquesSheet = true
        case .map:
            showingMapSheet = true
        }
    }
} 