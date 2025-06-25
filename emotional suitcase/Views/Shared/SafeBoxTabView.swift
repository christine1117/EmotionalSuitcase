// SafeBoxTabView.swift - 移除 TabButton 定義，使用本地命名
import SwiftUI

struct SafeBoxTabView: View {
    @ObservedObject var safeBoxManager: SafeBoxManager
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 自定義分頁標籤
            HStack(spacing: 0) {
                SafeBoxTabButton(title: "照片", isSelected: selectedTab == 0) {  // 重新命名
                    selectedTab = 0
                }
                SafeBoxTabButton(title: "影片", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                SafeBoxTabButton(title: "語音", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                
                Spacer()
                
                Button(action: {
                    // 添加新項目的功能
                    switch selectedTab {
                    case 0:
                        safeBoxManager.addPhoto(title: "新照片", description: "美好回憶")
                    case 1:
                        safeBoxManager.addVideo(title: "新影片", description: "放鬆時光")
                    case 2:
                        safeBoxManager.addAudio(title: "新錄音", duration: 60)
                    default:
                        break
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text(selectedTab == 0 ? "新增照片" : selectedTab == 1 ? "新增影片" : "新增語音")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.orange)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            
            // 分頁內容
            TabView(selection: $selectedTab) {
                PhotoGridView(photos: safeBoxManager.photos, safeBoxManager: safeBoxManager)
                    .tag(0)
                
                VideoGridView(videos: safeBoxManager.videos, safeBoxManager: safeBoxManager)
                    .tag(1)
                
                AudioListView(audios: safeBoxManager.audios, safeBoxManager: safeBoxManager)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(AppColors.lightYellow)
    }
}

struct SafeBoxTabButton: View {  // 本地專用的 TabButton
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? AppColors.orange : AppColors.darkBrown)
                .padding(.bottom, 8)
                .overlay(
                    Rectangle()
                        .fill(isSelected ? AppColors.orange : Color.clear)
                        .frame(height: 2)
                        .offset(y: 4),
                    alignment: .bottom
                )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SafeBoxTabView(safeBoxManager: SafeBoxManager())
}
