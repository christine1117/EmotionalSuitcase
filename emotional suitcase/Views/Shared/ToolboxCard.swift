import SwiftUI

struct ToolboxCard: View {
    let title: String
    let description: String
    let buttonText: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 標題背景條 - 垂直置中
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(backgroundColor)
            
            // 內容區域 - 靠左對齊
            VStack(alignment: .leading, spacing: 0) {
                // 描述 - 靠左對齊
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColors.darkBrown)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                // 按鈕區域 - 靠左對齊
                HStack {
                    Button(action: action) {
                        Text(buttonText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(backgroundColor)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
            }
            .padding(15)
        }
        .frame(width: 220, height: 140)
        .background(Color.white)
        .cornerRadius(10)
        .clipped()
    }
}

#Preview {
    HStack {
        ToolboxCard(
            title: "支援我的片刻",
            description: "記下那些讓你有動力繼續向前的理由。",
            buttonText: "查看我的理由",
            backgroundColor: Color(red: 0.95, green: 0.75, blue: 0.30),
            action: {}
        )
        
        ToolboxCard(
            title: "安心收藏箱",
            description: "收藏能給你帶來安全感和力量的影片、照片和語音。",
            buttonText: "打開收藏箱",
            backgroundColor: AppColors.orange,
            action: {}
        )
    }
    .padding()
    .background(AppColors.lightYellow)
}
