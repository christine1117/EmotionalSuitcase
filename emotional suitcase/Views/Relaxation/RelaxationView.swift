import SwiftUI

struct RelaxationView: View {
    @StateObject private var viewModel = RelaxationViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("放鬆小技巧")
                .font(.title)
                .fontWeight(.bold)
            ForEach(viewModel.relaxationTips) { tip in
                VStack(alignment: .leading, spacing: 8) {
                    Text(tip.title)
                        .font(.headline)
                    Text(tip.description)
                        .font(.subheadline)
                }
                .padding()
                .background(AppColors.backgroundLight)
                .cornerRadius(12)
            }
            Button("重新整理") {
                viewModel.refresh()
            }
        }
        .padding()
        .onAppear {
            viewModel.refresh()
        }
    }
}

#Preview {
    RelaxationView()
}
