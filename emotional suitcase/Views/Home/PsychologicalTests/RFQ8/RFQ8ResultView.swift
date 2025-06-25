import SwiftUI

struct RFQ8ResultView: View {
    let rfqCScore: Int
    let rfqUScore: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            
            Text("RFQ-8 測試結果")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            
            VStack(spacing: 16) {
                // RFQ-C 分數
                VStack(spacing: 8) {
                    Text("過度心智化分數 (RFQ-C)")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    
                    Text("\(rfqCScore)/18")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.1))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2)
                
                // RFQ-U 分數
                VStack(spacing: 8) {
                    Text("心智化缺陷分數 (RFQ-U)")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    
                    Text("\(rfqUScore)/18")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.1))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 量表說明：")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• RFQ-C：評估對心理狀態的過度確信")
                    Text("• RFQ-U：評估對心理狀態的不確定性")
                    Text("• 兩個分數都較低表示心智化能力良好")
                }
                .font(.body)
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2)
            
            Button(action: { isPresented = false }) {
                Text("完成")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.4, green: 0.2, blue: 0.1))
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.996, green: 0.953, blue: 0.780))
    }
}
