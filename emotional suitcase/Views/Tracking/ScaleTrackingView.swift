// ScaleTracking/ScaleTrackingView.swift
import SwiftUI

struct ScaleTrackingView: View {
    @ObservedObject var viewModel: TrackingViewModel
    @State private var selectedScale: ScaleType?
    @State private var showingScaleDetail = false
    @State private var showingPHQ9Test = false
    @State private var showingGAD7Test = false
    @State private var showingBSRS5Test = false
    @State private var showingRFQ8Test = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 選擇量表
                SectionCard(title: "選擇量表", subtitle: "選擇要進行的心理量表測驗") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(ScaleType.allCases, id: \.self) { scale in
                            ScaleSelectionCard(
                                scale: scale,
                                lastRecord: viewModel.getLastRecord(for: scale),
                                onTap: {
                                    // 連接到對應的測驗檔案
                                    switch scale {
                                    case .phq9:
                                        showingPHQ9Test = true
                                    case .gad7:
                                        showingGAD7Test = true
                                    case .bsrs5:
                                        showingBSRS5Test = true
                                    case .rfq8:
                                        showingRFQ8Test = true
                                    }
                                }
                            )
                        }
                    }
                }
                
                // 最近紀錄 - 改為四欄佈局
                SectionCard(title: "測驗紀錄", subtitle: "查看各量表的歷史趨勢") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(ScaleType.allCases, id: \.self) { scale in
                            ScaleHistoryCard(
                                scale: scale,
                                records: viewModel.getRecords(for: scale),
                                onTap: {
                                    selectedScale = scale
                                    showingScaleDetail = true
                                }
                            )
                        }
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingScaleDetail) {
            if let scale = selectedScale {
                ScaleTrendAnalysisView(
                    scale: scale,
                    records: viewModel.getRecords(for: scale)
                )
            }
        }
        // 修正：添加 isPresented 參數
        .sheet(isPresented: $showingPHQ9Test) {
            PHQ9TestView(isPresented: $showingPHQ9Test)
        }
        .sheet(isPresented: $showingGAD7Test) {
            GAD7TestView(isPresented: $showingGAD7Test)
        }
        .sheet(isPresented: $showingBSRS5Test) {
            BSRS5TestView(isPresented: $showingBSRS5Test)
        }
        .sheet(isPresented: $showingRFQ8Test) {
            RFQ8TestView(isPresented: $showingRFQ8Test)
        }
        .background(AppColors.yellowLight)
    }
}

#Preview {
    ScaleTrackingView(viewModel: TrackingViewModel())
        .background(AppColors.yellowLight)
}
