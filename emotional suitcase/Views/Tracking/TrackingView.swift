// TrackingView.swift
import SwiftUI

struct TrackingView: View {
    @ObservedObject private var viewModel = TrackingViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("心情追蹤")
                .font(.title)
                .fontWeight(.bold)
            ForEach(viewModel.moodEntries) { entry in
                HStack {
                    Text("\(entry.date, formatter: dateFormatter)")
                    Spacer()
                    Text(entry.mood)
                }
                .padding()
                .background(AppColors.backgroundLight)
                .cornerRadius(12)
            }
            Button("重新整理") {
                viewModel.refreshAll()
            }
        }
        .padding()
        .onAppear {
            viewModel.refreshAll()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    TrackingView()
}
