import SwiftUI

struct EmotionalToolboxSection: View {
    @Binding var showingSafeBox: Bool
    @Binding var showingSupportPlan: Bool
    @Binding var showingSafetyPlan: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 情緒行李箱標題
            HStack {
                Text("情緒行李箱")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.darkBrown)
                Spacer()
            }
            
            // 可水平滾動的情緒行李箱卡片
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    // 支援我的片刻
                    ToolboxCard(
                        title: "支援我的片刻",
                        description: "記下那些讓你有動力繼續向前的理由。",
                        buttonText: "查看我的理由",
                        backgroundColor: Color(red: 0.95, green: 0.75, blue: 0.30),
                        action: { showingSupportPlan = true }
                    )
                    
                    // 安心收藏箱
                    ToolboxCard(
                        title: "安心收藏箱",
                        description: "收藏能給你帶來安全感和力量的影片、照片和語音。",
                        buttonText: "打開收藏箱",
                        backgroundColor: AppColors.orange,
                        action: { showingSafeBox = true }
                    )
                    
                    // 安全計畫
                    ToolboxCard(
                        title: "安全計畫",
                        description: "制定專屬於你的安全計畫，幫助你度過困難時刻。",
                        buttonText: "查看我的安全計畫",
                        backgroundColor: AppColors.mediumBrown,
                        action: { showingSafetyPlan = true }
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    EmotionalToolboxSection(
        showingSafeBox: .constant(false),
        showingSupportPlan: .constant(false),
        showingSafetyPlan: .constant(false)
    )
    .padding()
    .background(AppColors.lightYellow)
}
