import SwiftUI

struct DailyReminderCard: View {
    let quote: String
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("今日提醒")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.darkBrown)
            
            Text(quote)
                .font(.caption)
                .foregroundColor(AppColors.darkBrown)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onRefresh()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("換一句")
                    }
                    .font(.caption)
                    .foregroundColor(AppColors.darkBrown)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.95, green: 0.75, blue: 0.30), Color(red: 0.98, green: 0.85, blue: 0.50)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
    }
}

#Preview {
    DailyReminderCard(
        quote: "你的故事還沒有結束，最精彩的篇章還在後面",
        onRefresh: {}
    )
    .padding()
    .background(AppColors.lightYellow)
}
