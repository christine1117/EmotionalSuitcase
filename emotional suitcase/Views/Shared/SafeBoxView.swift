import SwiftUI

struct SafeBoxView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var safeBoxManager = SafeBoxManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 導航標題區域
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("✕")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("安心收藏箱")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // 佔位符保持平衡
                    Text("✕")
                        .font(.title2)
                        .opacity(0)
                }
                .padding()
                .background(AppColors.orange) // 橘色 - 對應安心收藏箱
                
                // 內容區域
                SafeBoxTabView(safeBoxManager: safeBoxManager)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SafeBoxView()
}
