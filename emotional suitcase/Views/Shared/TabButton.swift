// Common/TabButton.swift
import SwiftUI  // 確保有這個 import

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.darkBrown.opacity(0.6))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.darkBrown.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppColors.orange.opacity(0.1) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack {
        TabButton(title: "心情日記", icon: "heart.text.square", isSelected: true, action: {})
        TabButton(title: "健康數據", icon: "chart.line.uptrend.xyaxis", isSelected: false, action: {})
        TabButton(title: "量表追蹤", icon: "list.clipboard", isSelected: false, action: {})
    }
    .padding()
    .background(Color.white)
}
