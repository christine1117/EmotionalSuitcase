import SwiftUI

struct RFQ8TestView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PsychologicalTestsViewModel
    let questions = [
        "我總是知道自己為什麼會有某種感覺", // 1 - RFQ-C
        "我的情緒常常令我困惑", // 2 - RFQ-C & RFQ-U
        "當我心煩意亂時，我不知道自己是悲傷、害怕還是憤怒", // 3 - RFQ-C
        "我常常困惑於自己的感受", // 4 - RFQ-C & RFQ-U
        "我常常不確定自己的感受", // 5 - RFQ-C & RFQ-U
        "當別人告訴我他們對我的感受時，我感到困惑", // 6 - RFQ-C & RFQ-U
        "我的感受對我來說是個謎", // 7 - RFQ-U
        "我常常不知道為什麼我會生氣" // 8 - RFQ-U
    ]
    let options = ["非常不同意", "不同意", "有點不同意", "中性", "有點同意", "同意", "非常同意"]
    var body: some View {
        NavigationView {
            if viewModel.isCompleted {
                RFQ8ResultView(
                    rfqCScore: viewModel.calculateRFQ8CScore(),
                    rfqUScore: viewModel.calculateRFQ8UScore(),
                    isPresented: $isPresented
                )
            } else {
                VStack(spacing: 20) {
                    ProgressView(value: Double(viewModel.currentStep + 1), total: Double(questions.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.4, green: 0.2, blue: 0.1)))
                    Text("第 \(viewModel.currentStep + 1) 題，共 \(questions.count) 題")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1).opacity(0.7))
                    VStack(alignment: .leading, spacing: 16) {
                        Text("請根據您的實際情況選擇最符合的選項：")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                        Text(questions[viewModel.currentStep])
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                    }
                    ScrollView {
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
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 2)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(red: 0.996, green: 0.953, blue: 0.780))
                .navigationTitle("RFQ-8 反思功能量表")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("取消") { isPresented = false })
            }
        }
    }
    private func selectAnswer(_ answer: Int) {
        viewModel.rfq8Answers[viewModel.currentStep] = answer
        if viewModel.currentStep < questions.count - 1 {
            viewModel.currentStep += 1
        } else {
            viewModel.isCompleted = true
        }
    }
}
