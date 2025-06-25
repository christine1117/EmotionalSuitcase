import SwiftUI

struct BSRS5ResultView: View {
    let score: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.clipboard.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            
            Text("BSRS-5 測試完成")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            
            VStack(spacing: 12) {
                Text("您的心理症狀指數")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                
                Text("\(score)/20")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.1))
                
                Text("請尋求專業協助。")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4)
            
            Text("請尋求專業協助。")
                .font(.body)
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2)
            
            if score >= 10 {
                VStack(spacing: 8) {
                    Text("⚠️ 重要提醒")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("您的測試結果顯示有較明顯的情緒困擾，建議尋求專業協助。")
                        .font(.body)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
            
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
        .navigationTitle("測試結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}
