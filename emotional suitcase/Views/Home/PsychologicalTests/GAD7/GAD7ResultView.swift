import SwiftUI

struct GAD7ResultView: View {
    let score: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(AppColors.brownDeep)
            
            Text("GAD-7 測試完成")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppColors.brownDeep)
            
            VStack(spacing: 12) {
                Text("您的焦慮指數")
                    .font(.headline)
                    .foregroundColor(AppColors.brownDeep)
                
                Text("\(score)/21")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(AppColors.orangeMain)
                
                Text("焦慮程度")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.brownDeep)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4)
            
            Text("建議")
                .font(.body)
                .foregroundColor(AppColors.brownDeep)
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
                    Text("您的測試結果顯示可能有較嚴重的焦慮症狀，建議尋求專業醫療協助。")
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
                    .background(AppColors.brownDeep)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.backgroundLight)
        .navigationTitle("測試結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}
