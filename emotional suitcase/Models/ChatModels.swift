import Foundation

// MARK: - 治療模式
enum TherapyMode: String, CaseIterable, Codable {
    case chatMode = "chat"
    case cbtMode = "cbt"
    case mbtMode = "mbt"
}

// MARK: - 聊天訊息
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    let mode: TherapyMode
    
    init(id: UUID = UUID(), content: String, isFromUser: Bool, timestamp: Date = Date(), mode: TherapyMode) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.mode = mode
    }
}

// MARK: - 聊天會話
struct ChatSession: Identifiable, Codable {
    let id: UUID
    var title: String
    var therapyMode: TherapyMode
    var lastMessage: String
    var lastUpdated: Date
    var tags: [String]
    var messageCount: Int
    
    init(id: UUID = UUID(), title: String, therapyMode: TherapyMode, lastMessage: String = "", lastUpdated: Date = Date(), tags: [String] = [], messageCount: Int = 0) {
        self.id = id
        self.title = title
        self.therapyMode = therapyMode
        self.lastMessage = lastMessage
        self.lastUpdated = lastUpdated
        self.tags = tags
        self.messageCount = messageCount
    }
}
