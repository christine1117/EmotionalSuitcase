// MoodDiary/MonthlyMoodAnalysisView.swift
import SwiftUI

struct MonthlyMoodAnalysisView: View {
    @ObservedObject var viewModel: TrackingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMonth = Date()
    @State private var commonWords: [(String, Int)] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // AI 分析結果
                    SectionCard(title: "AI 情緒分析", subtitle: dateFormatter.string(from: selectedMonth)) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("本月情緒概況")
                                .font(.headline)
                                .foregroundColor(AppColors.darkBrown)
                            
                            Text("根據你這個月的心情記錄，AI 分析顯示你的整體情緒狀態偏向積極。建議繼續保持良好的生活習慣，適當放鬆心情。")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                            
                            // 情緒分布圖
                            EmotionDistributionChart(entries: viewModel.getCurrentMonthEntries(selectedMonth: selectedMonth))
                        }
                    }
                    
                    // 常用字分析
                    SectionCard(title: "常用字分析", subtitle: "本月日記關鍵詞彙") {
                        CommonWordsAnalysis(commonWords: viewModel.analyzeCommonWords(selectedMonth: selectedMonth))
                    }
                    
                    // 情緒趨勢
                    SectionCard(title: "情緒趨勢") {
                        MoodTrendChart(entries: viewModel.getCurrentMonthEntries(selectedMonth: selectedMonth))
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(AppColors.lightYellow)
            .navigationTitle("月度分析")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                }
            }
        }
    }
}

struct CommonWordsAnalysis: View {
    let commonWords: [(String, Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if commonWords.isEmpty {
                Text("本月還沒有足夠的日記內容進行分析")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                Text("最常出現的詞彙")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkBrown)
                
                // 詞雲風格的標籤
                FlowLayout(spacing: 8) {
                    ForEach(Array(commonWords.enumerated()), id: \.offset) { index, wordData in
                        WordTag(
                            word: wordData.0,
                            count: wordData.1,
                            rank: index + 1
                        )
                    }
                }
                
                // 詞頻排行
                VStack(alignment: .leading, spacing: 6) {
                    Text("詞頻統計")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.darkBrown)
                        .padding(.top, 10)
                    
                    ForEach(Array(commonWords.prefix(5).enumerated()), id: \.offset) { index, wordData in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(width: 20, alignment: .leading)
                            
                            Text(wordData.0)
                                .font(.caption)
                                .foregroundColor(AppColors.darkBrown)
                            
                            Spacer()
                            
                            Text("\(wordData.1)次")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct WordTag: View {
    let word: String
    let count: Int
    let rank: Int
    
    private var tagColor: Color {
        switch rank {
        case 1: return AppColors.orange
        case 2: return Color(red: 0.95, green: 0.75, blue: 0.30)
        case 3: return AppColors.mediumBrown
        default: return Color.gray.opacity(0.6)
        }
    }
    
    private var fontSize: CGFloat {
        switch rank {
        case 1: return 16
        case 2: return 14
        case 3: return 12
        default: return 10
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(word)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.white)
            
            Text("\(count)")
                .font(.system(size: fontSize - 2, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tagColor)
        .cornerRadius(12)
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.bounds
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }
}

struct FlowResult {
    var bounds = CGSize.zero
    var positions: [CGPoint] = []
    
    init(in maxWidth: CGFloat, subviews: LayoutSubviews, spacing: CGFloat) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += lineHeight + spacing
                lineHeight = 0
            }
            
            positions.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        bounds = CGSize(width: maxWidth, height: y + lineHeight)
    }
}

// 保持原有的其他結構體...
struct EmotionDistributionChart: View {
    let entries: [MoodEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(MoodType.allCases, id: \.self) { mood in
                let count = entries.filter { $0.mood == mood }.count
                let percentage = entries.isEmpty ? 0 : Double(count) / Double(entries.count)
                
                HStack {
                    Text(mood.emoji)
                    Text(mood.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.darkBrown)
                    
                    Spacer()
                    
                    Text("\(count)次")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                ProgressView(value: percentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: mood.color))
                    .scaleEffect(x: 1, y: 0.5)
            }
        }
    }
}

struct MoodTrendChart: View {
    let entries: [MoodEntry]
    
    var body: some View {
        VStack {
            Text("情緒趨勢圖")
                .font(.caption)
                .foregroundColor(.gray)
            
            Rectangle()
                .fill(AppColors.orange.opacity(0.3))
                .frame(height: 100)
                .cornerRadius(8)
                .overlay(
                    Text("趨勢圖表")
                        .foregroundColor(AppColors.orange)
                )
        }
    }
}

#Preview {
    MonthlyMoodAnalysisView(viewModel: TrackingViewModel())
}
