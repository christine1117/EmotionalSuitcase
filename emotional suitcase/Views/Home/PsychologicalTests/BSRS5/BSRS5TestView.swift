import SwiftUI

struct BSRS5TestView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PsychologicalTestsViewModel
    let questions = [
        "睡眠困難，如難以入睡、易醒或早醒",
        "感覺緊張或不安",
        "容易苦惱或動怒",
        "感覺憂鬱、心情低落",
        "覺得比不上別人"
    ]
    let options = ["完全沒有", "輕微", "中等程度", "嚴重", "非常嚴重"]
    var body: some View {
        NavigationView {
            if viewModel.isCompleted {
                BSRS5ResultView(score: viewModel.calculateBSRS5Score(), isPresented: $isPresented)
            } else {
                VStack(spacing: 20) {
                    ProgressView(value: Double(viewModel.currentStep + 1), total: Double(questions.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.4, green: 0.2, blue: 0.1)))
                    Text("第 \(viewModel.currentStep + 1) 題，共 \(questions.count) 題")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1).opacity(0.7))
                    VStack(alignment: .leading, spacing: 16) {
                        Text("在過去一週內，您有多常被以下的問題所困擾：")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
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
                                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                                    Spacer()
                                    Text("(\(index)分)")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1).opacity(0.6))
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
                .navigationTitle("BSRS-5 心理症狀量表")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("取消") { isPresented = false })
            }
        }
    }
    private func selectAnswer(_ answer: Int) {
        viewModel.bsrs5Answers[viewModel.currentStep] = answer
        if viewModel.currentStep < questions.count - 1 {
            viewModel.currentStep += 1
        } else {
            viewModel.isCompleted = true
        }
    }
}
