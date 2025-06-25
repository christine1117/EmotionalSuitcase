import SwiftUI
import ViewModels.Relaxation.RelaxationViewModel
import Models.RelaxationModels
import "emotional suitcase/Views/Relaxation/Components/BreathingGuideView.swift"
import "emotional suitcase/Views/Relaxation/Components/HRVChartView.swift"
import "emotional suitcase/Views/Relaxation/Components/RelaxationTipsView.swift"

struct BreathingView: View {
    let configuration: TimerConfiguration
    @ObservedObject var viewModel: RelaxationViewModel
    
    @State private var showingTip = false
    @State private var currentTip: RelaxationTip?
    @State private var showHRV = false  // 預設不顯示，需要手動連接
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.996, green: 0.953, blue: 0.780),
                    viewModel.breathingManager.currentPhase.color.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 頂部控制欄 - 白底
                HStack {
                    Button(action: {
                        viewModel.timerManager.stopTimer()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("呼吸練習")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                        
                        Text(viewModel.breathingManager.pattern.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if viewModel.timerManager.timerState == .running {
                            viewModel.timerManager.pauseTimer()
                        } else if viewModel.timerManager.timerState == .paused {
                            viewModel.timerManager.resumeTimer()
                        }
                    }) {
                        Image(systemName: viewModel.timerManager.timerState == .running ? "pause" : "play")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                
                Spacer()
                
                // 呼吸引導區域
                VStack(spacing: 40) {
                    // 時間顯示
                    Text(viewModel.timerManager.formattedTimeRemaining)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    
                    // 呼吸引導圓圈
                    BreathingGuideView(
                        phase: viewModel.breathingManager.currentPhase,
                        progress: viewModel.breathingManager.phaseProgress,
                        scale: viewModel.breathingManager.circleScale
                    )
                    
                    // 階段指示
                    VStack(spacing: 8) {
                        Text(viewModel.breathingManager.currentPhase.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.breathingManager.currentPhase.color)
                        
                        Text(viewModel.breathingManager.currentPhase.instruction)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // 階段倒計時
                        Text(String(format: "%.0f", viewModel.breathingManager.phaseTimeRemaining))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(viewModel.breathingManager.currentPhase.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(viewModel.breathingManager.currentPhase.color.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
                
                // HRV 圖表區域（只有連接且開啟顯示才顯示）
                if showHRV && viewModel.hrvManager.isConnected {
                    VStack(spacing: 12) {
                        HStack {
                            Text("心率變異性")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showHRV = false
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(viewModel.hrvManager.hrvTrend.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(viewModel.hrvManager.hrvTrend.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        HRVChartView()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                // 底部統計信息
                HStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text("呼吸週期")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(viewModel.breathingManager.completedCycles)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    }
                    
                    if showHRV && viewModel.hrvManager.isConnected {
                        VStack(spacing: 4) {
                            Text("當前HRV")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(String(format: "%.1f", viewModel.hrvManager.currentHRV))
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text("進度")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(String(format: "%.0f%%", viewModel.timerManager.progress * 100))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    }
                }
                .padding(.bottom, 100) // 給右下角按鈕留空間
            }
        }
        .overlay(
            // HRV 連接/顯示按鈕（右下角）
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    if !viewModel.hrvManager.isConnected {
                        // 未連接 - 顯示連接按鈕
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.hrvManager.connectDevice()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.circle")
                                    .font(.title3)
                                
                                Text("連接HRV")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 0.8, green: 0.4, blue: 0.1))
                                    .shadow(color: Color(red: 0.8, green: 0.4, blue: 0.1).opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // 已連接 - 顯示開啟/關閉 HRV 顯示按鈕
                        Button(action: {
                            withAnimation(.spring()) {
                                showHRV.toggle()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: showHRV ? "heart.circle.fill" : "heart.circle")
                                    .font(.title3)
                                
                                Text(showHRV ? "隱藏HRV" : "顯示HRV")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(showHRV ? Color.green : Color(red: 0.8, green: 0.4, blue: 0.1))
                                    .shadow(color: (showHRV ? Color.green : Color(red: 0.8, green: 0.4, blue: 0.1)).opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        )
        .overlay(
            // 提示彈窗
            tipOverlay
        )
        .onAppear {
            setupSession()
        }
        .onChange(of: viewModel.timerManager.elapsedMinutes) { oldValue, newValue in
            checkForTips(at: newValue)
        }
        .onReceive(viewModel.timerManager.$timerState) { state in
            if state == .completed {
                completeSession()
            }
        }
    }
    
    private var tipOverlay: some View {
        Group {
            if showingTip, let tip = currentTip {
                RelaxationTipsView(
                    tip: tip,
                    isShowing: $showingTip
                )
            }
        }
    }
    
    private func setupSession() {
        if let pattern = configuration.breathingPattern {
            viewModel.breathingManager.setPattern(pattern)
        }
        viewModel.timerManager.configure(totalTime: configuration.totalSeconds)
        viewModel.timerManager.startTimer()
        viewModel.breathingManager.startBreathing()
    }
    
    private func checkForTips(at minutes: Int) {
        let availableTips = RelaxationTip.tips.filter { tip in
            tip.mode == .breathing && tip.timeRange.contains(minutes)
        }
        
        if let tip = availableTips.randomElement(), !showingTip {
            currentTip = tip
            showingTip = true
        }
    }
    
    private func completeSession() {
        viewModel.breathingManager.stopBreathing()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    BreathingView(
        configuration: TimerConfiguration(
            totalMinutes: 5,
            mode: .breathing,
            breathingPattern: BreathingPattern.patterns[0]
        )
    )
}
