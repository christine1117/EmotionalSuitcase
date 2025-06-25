import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 標題區域
                HStack {
                    Text("聊天紀錄")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showingNewChat = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("新對話")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(AppColors.orangeMain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // 搜尋框
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("搜尋對話...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.backgroundLight)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // 聊天列表
                if viewModel.filteredChats.isEmpty {
                    EmptyChatState(onNewChat: {
                        viewModel.showingNewChat = true
                    })
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredChats) { session in
                                NavigationLink(destination: ChatDetailView(session: session)) {
                                    ChatListItemView(session: session)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    // 刪除按鈕
                                    Button(role: .destructive, action: {
                                        viewModel.deleteSession(session)
                                    }) {
                                        Label("刪除", systemImage: "trash")
                                    }
                                    
                                    // 編輯按鈕
                                    Button(action: {
                                        // TODO: 實現編輯功能
                                    }) {
                                        Label("編輯", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                                .contextMenu {
                                    Button(action: {
                                        // TODO: 分享功能
                                    }) {
                                        Label("分享對話", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    Button(action: {
                                        // TODO: 標記重要
                                    }) {
                                        Label("標記重要", systemImage: "star")
                                    }
                                    
                                    Divider()
                                    
                                    Button(role: .destructive, action: {
                                        viewModel.deleteSession(session)
                                    }) {
                                        Label("刪除對話", systemImage: "trash")
                                    }
                                }
                                
                                if session.id != viewModel.filteredChats.last?.id {
                                    Divider()
                                        .padding(.leading, 80)
                                }
                            }
                            .onDelete(perform: viewModel.deleteSessionsAtOffsets)
                        }
                        .padding(.top, 16)
                    }
                }
                
                Spacer()
            }
            .background(Color.white)
            .sheet(isPresented: $viewModel.showingNewChat) {
                NewChatView(
                    isPresented: $viewModel.showingNewChat,
                    onChatCreated: { session in
                        viewModel.newChatSession = session
                        viewModel.navigateToNewChat = true
                    }
                )
            }
            .background(
                // 隱藏的 NavigationLink，用於程式化導航
                NavigationLink(
                    destination: Group {
                        if let session = viewModel.newChatSession {
                            ChatDetailView(session: session)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $viewModel.navigateToNewChat
                ) {
                    EmptyView()
                }
                .hidden()
            )
            .alert("確認刪除", isPresented: $viewModel.showingDeleteAlert) {
                Button("取消", role: .cancel) {
                    viewModel.cancelDeleteSession()
                }
                Button("刪除", role: .destructive) {
                    viewModel.confirmDeleteSession()
                }
            } message: {
                if let session = viewModel.sessionToDelete {
                    Text("確定要刪除「\(session.title)」對話嗎？此操作無法復原。")
                }
            }
        }
    }
}

// MARK: - 聊天列表項目
struct ChatListItemView: View {
    let session: ChatSession
    
    var body: some View {
        HStack(spacing: 16) {
            // 模式圖標
            ZStack {
                Circle()
                    .fill(session.therapyMode.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(session.therapyMode.shortName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(session.therapyMode.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.brownDeep)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(formatDate(session.lastUpdated))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(session.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if !session.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(session.tags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.backgroundLight)
                                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.1))
                                .cornerRadius(8)
                        }
                        
                        if session.tags.count > 2 {
                            Text("+\(session.tags.count - 2)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(date) == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "zh_Hant_TW")
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d"
            return formatter.string(from: date)
        }
    }
}

// MARK: - 空狀態視圖
struct EmptyChatState: View {
    let onNewChat: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 64))
                    .foregroundColor(.gray.opacity(0.6))
                
                Text("還沒有聊天紀錄")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("開始您的第一次心靈對話")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.8))
            }
            
            Button(action: onNewChat) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("開始新對話")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.orangeMain)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
}

// MARK: - 新對話視圖
struct NewChatView: View {
    @Binding var isPresented: Bool
    let onChatCreated: (ChatSession) -> Void
    @State private var selectedMode: TherapyMode = .chatMode
    @ObservedObject private var chatManager = ChatManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("選擇對話模式")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text("選擇最適合您當前需求的對話方式")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                
                VStack(spacing: 16) {
                    ForEach(TherapyMode.allCases, id: \.self) { mode in
                        TherapyModeSelectionCard(
                            mode: mode,
                            isSelected: selectedMode == mode,
                            onSelect: {
                                selectedMode = mode
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    let newSession = chatManager.createNewSession(mode: selectedMode)
                    isPresented = false
                    onChatCreated(newSession)
                }) {
                    Text("開始對話")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.orangeMain)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(AppColors.backgroundLight)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { isPresented = false }
            )
        }
    }
}

// MARK: - 治療模式選擇卡片
struct TherapyModeSelectionCard: View {
    let mode: TherapyMode
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // 模式圖標
                ZStack {
                    Circle()
                        .fill(mode.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(mode.shortName)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(mode.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(mode.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(mode.color)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? mode.color : Color.gray.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChatListView()
}
