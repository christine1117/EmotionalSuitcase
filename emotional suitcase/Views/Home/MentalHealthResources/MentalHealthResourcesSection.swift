import SwiftUI

struct MentalHealthResourcesSection: View {
    @ObservedObject var viewModel: MentalHealthResourcesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("心理健康資源")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    .padding(.leading, 16)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.resources) { resource in
                        MentalHealthResourceCard(
                            resource: resource,
                            onTap: {
                                viewModel.showSheet(for: resource.action)
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $viewModel.showingHotlineSheet) {
            HotlineDetailView(isPresented: $viewModel.showingHotlineSheet)
        }
        .sheet(isPresented: $viewModel.showingGuideSheet) {
            GuideDetailView(isPresented: $viewModel.showingGuideSheet)
        }
        .sheet(isPresented: $viewModel.showingTechniquesSheet) {
            TechniquesDetailView(isPresented: $viewModel.showingTechniquesSheet)
        }
        .sheet(isPresented: $viewModel.showingMapSheet) {
            MapDetailView(isPresented: $viewModel.showingMapSheet)
        }
    }
}
