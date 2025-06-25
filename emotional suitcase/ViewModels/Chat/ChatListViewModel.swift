import Foundation
import Combine

final class ChatListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingNewChat: Bool = false
    @Published var navigateToNewChat: Bool = false
    @Published var newChatSession: ChatSession? = nil
    @Published var showingDeleteAlert: Bool = false
    @Published var sessionToDelete: ChatSession? = nil
    
    @Published private(set) var chatSessions: [ChatSession] = []
    private var cancellables = Set<AnyCancellable>()
    private let chatService: ChatService
    
    init(chatService: ChatService = .shared) {
        self.chatService = chatService
        chatService.$chatSessions
            .assign(to: &$chatSessions)
    }
    
    var filteredChats: [ChatSession] {
        if searchText.isEmpty {
            return chatSessions
        } else {
            return chatSessions.filter { session in
                session.title.localizedCaseInsensitiveContains(searchText) ||
                session.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func createNewSession(mode: TherapyMode) {
        let session = chatService.createNewSession(mode: mode)
        newChatSession = session
        navigateToNewChat = true
    }
    
    func deleteSession(_ session: ChatSession) {
        sessionToDelete = session
        showingDeleteAlert = true
    }
    
    func confirmDeleteSession() {
        if let session = sessionToDelete {
            chatService.deleteSession(session.id)
            sessionToDelete = nil
        }
    }
    
    func cancelDeleteSession() {
        sessionToDelete = nil
    }
    
    func deleteSessionsAtOffsets(_ offsets: IndexSet) {
        for index in offsets {
            let session = filteredChats[index]
            chatService.deleteSession(session.id)
        }
    }
    
    // MARK: - 訊息管理與 AI 回覆
    // TODO: 將所有訊息管理、AI 回覆、模式切換等邏輯集中於本 ViewModel，供 ChatDetailView 使用。
} 