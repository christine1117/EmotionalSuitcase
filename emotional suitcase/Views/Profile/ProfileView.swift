import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("個人資料")
                .font(.title)
                .fontWeight(.bold)
            Text("姓名：\(viewModel.profileData.name)")
            Text("年齡：\(viewModel.profileData.age)")
            Text("信箱：\(viewModel.profileData.email)")
            Button("更新資料") {
                // 範例：更新資料
                let updated = ProfileData(name: "新名字", age: 30, email: "new@email.com")
                viewModel.updateProfile(updated)
            }
        }
        .padding()
        .onAppear {
            Task {
                try? await viewModel.fetchProfile()
            }
        }
    }
}

// 假設 ProfileData 已在 Models/ProfileData.swift 定義

#Preview {
    ProfileView()
}
