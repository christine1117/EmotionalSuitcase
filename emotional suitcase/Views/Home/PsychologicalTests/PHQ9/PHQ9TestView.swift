import SwiftUI

struct PHQ9TestView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PsychologicalTestsViewModel
    let questions = [
        "做事時提不起勁或沒有樂趣",
        "感到心情低落、沮喪或絕望",
        "入睡困難、睡不安穩或睡眠過多",
        "感覺疲倦或沒有活力",
        "食慾不振或吃太多",
        "覺得自己很糟糕，或覺得自己很失敗，或讓自己或家人失望",
        "對事物專注有困難，例如閱讀報紙或看電視時",
        "動作或說話速度緩慢到別人已經察覺？或正好相反－煩躁或坐立不安、動來動去的情況更勝於平常",
        "有不如死掉或用某種方式傷害自己的念頭"
    ]
    let options = ["完全沒有", "好幾天", "一半以上的天數", "幾乎每天"]
    var body: some View {
        NavigationView {
            if viewModel.isCompleted {
                PHQ9ResultView(score: viewModel.calculatePHQ9Score(), isPresented: $isPresented)
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
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 2)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(red: 0.996, green: 0.953, blue: 0.780))
                .navigationTitle("PHQ-9 憂鬱症篩檢")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("取消") { isPresented = false })
            }
        }
    }
    private func selectAnswer(_ answer: Int) {
        viewModel.phq9Answers[viewModel.currentStep] = answer
        if viewModel.currentStep < questions.count - 1 {
            viewModel.currentStep += 1
        } else {
            viewModel.isCompleted = true
        }
    }
}
