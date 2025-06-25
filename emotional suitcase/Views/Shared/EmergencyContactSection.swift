import SwiftUI

struct EmergencyContactSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("緊急聯絡")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.darkBrown)
                Spacer()
            }
            
            HStack(spacing: 15) {
                // 24小時救援專線
                EmergencyContactCard(
                    contact: EmergencyContact(
                        name: "24小時救援專線",
                        phone: "1925",
                        relationship: "依舊愛我"
                    )
                )
                
                // 我的支持者
                EmergencyContactCard(
                    contact: EmergencyContact(
                        name: "我的支持者",
                        phone: "0912-345-678",
                        relationship: "醫師"
                    )
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    EmergencyContactSection()
        .padding()
        .background(AppColors.lightYellow)
}
