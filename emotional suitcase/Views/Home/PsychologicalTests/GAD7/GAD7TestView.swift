import SwiftUI

struct GAD7TestView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PsychologicalTestsViewModel
    let questions = [
        "感覺緊張、焦慮或煩躁",
        "無法停止或控制憂慮",
        "對各種不同的事情過度擔心",
        "很難放鬆下來",
        "坐立不安，難以靜坐",
        "變得容易苦惱或急躁",
        "感覺害怕，好像將有可怕的事情發生"
    ]
    let options = ["完全沒有", "好幾天", "一半以上的天數", "幾乎每天"]
    var body: some View {
        NavigationView {
            if viewModel.isCompleted {
                GAD7ResultView(score: viewModel.calculateGAD7Score(), isPresented: $isPresented)
            } else {
                VStack(spacing: 20) {
                    ProgressView(value: Double(viewModel.currentStep + 1), total: Double(questions.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.brownDeep))
                    Text("第 \(viewModel.currentStep + 1) 題，共 \(questions.count) 題")
                        .font(.caption)
                        .foregroundColor(AppColors.brownDeep.opacity(0.7))
                    VStack(alignment: .leading, spacing: 16) {
                        Text("在過去兩週內，您有多常被以下的問題所困擾：")
                            .font(.subheadline)
                            .foregroundColor(AppColors.brownDeep)
                        Text(questions[viewModel.currentStep])
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                    }
                    VStack(spacing: 12) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Button(action: {
                                selectAnswer(index)
                            }) {
                                HStack {
                                    Text(options[index])
                                        .font(.body)
                                        .foregroundColor(AppColors.brownDeep)
                                    Spacer()
                                    Text("(\(index)分)")
                                        .font(.caption)
                                        .foregroundColor(AppColors.brownDeep.opacity(0.6))
                                }
                                .padding()
                                .background(AppColors.backgroundLight)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 2)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(AppColors.backgroundLight)
                .navigationTitle("GAD-7 焦慮症篩檢")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("取消") { isPresented = false })
            }
        }
    }
    private func selectAnswer(_ answer: Int) {
        viewModel.gad7Answers[viewModel.currentStep] = answer
        if viewModel.currentStep < questions.count - 1 {
            viewModel.currentStep += 1
        } else {
            viewModel.isCompleted = true
        }
    }
}
