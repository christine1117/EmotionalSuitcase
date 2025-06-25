import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            // 範例：生理節律卡片
            ForEach(viewModel.biorhythmData) { item in
                BiorhythmCard(date: item.date, value: item.value)
            }
            Button("重新整理") {
                viewModel.refresh()
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }
}

// 假設 BiorhythmCard 已抽離至 Views/Shared
struct BiorhythmCard: View {
    let date: Date
    let value: Double
    var body: some View {
        VStack {
            Text("\(date, formatter: dateFormatter)")
            Text("值：\(value, specifier: "%.2f")")
        }
        .padding()
        .background(AppColors.backgroundLight)
        .cornerRadius(12)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    HomeView()
}
