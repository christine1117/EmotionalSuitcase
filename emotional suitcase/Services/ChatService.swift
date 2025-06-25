import Foundation
import Combine

final class ChatService: ObservableObject {
    static let shared = ChatService()
    
    @Published private(set) var chatSessions: [ChatSession] = []
    @Published private(set) var messages: [UUID: [ChatMessage]] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let sessionsKey = "chatSessions"
    private let messagesKey = "chatMessages"
    
    private init() {
        loadData()
        createSampleDataIfNeeded()
    }
    
    // MARK: - CRUD
    func createNewSession(mode: TherapyMode) -> ChatSession {
        let session = ChatSession(
            title: generateSessionTitle(for: mode),
            therapyMode: mode,
            tags: [mode.shortName]
        )
        chatSessions.insert(session, at: 0)
        messages[session.id] = []
        addWelcomeMessage(to: session.id, mode: mode)
        saveData()
        return session
    }
    
    func updateSessionMode(_ sessionId: UUID, mode: TherapyMode) {
        if let index = chatSessions.firstIndex(where: { $0.id == sessionId }) {
            chatSessions[index].therapyMode = mode
            chatSessions[index].lastUpdated = Date()
            addMessage(
                to: sessionId,
                content: mode.welcomeMessage,
                isFromUser: false
            )
            saveData()
        }
    }
    
    func deleteSession(_ sessionId: UUID) {
        chatSessions.removeAll { $0.id == sessionId }
        messages.removeValue(forKey: sessionId)
        saveData()
    }
    
    func addMessage(to sessionId: UUID, content: String, isFromUser: Bool) {
        guard let sessionIndex = chatSessions.firstIndex(where: { $0.id == sessionId }) else { return }
        let session = chatSessions[sessionIndex]
        let message = ChatMessage(
            content: content,
            isFromUser: isFromUser,
            mode: session.therapyMode
        )
        if messages[sessionId] == nil {
            messages[sessionId] = []
        }
        messages[sessionId]?.append(message)
        chatSessions[sessionIndex].lastMessage = content
        chatSessions[sessionIndex].lastUpdated = Date()
        chatSessions[sessionIndex].messageCount = messages[sessionId]?.count ?? 0
        if isFromUser && messages[sessionId]?.filter({ $0.isFromUser }).count == 1 {
            let title = String(content.prefix(20)) + (content.count > 20 ? "..." : "")
            chatSessions[sessionIndex].title = title
        }
        let updatedSession = chatSessions[sessionIndex]
        chatSessions.remove(at: sessionIndex)
        chatSessions.insert(updatedSession, at: 0)
        saveData()
    }
    
    func getMessages(for sessionId: UUID) -> [ChatMessage] {
        return messages[sessionId] ?? []
    }
    
    func clearMessages(for sessionId: UUID) {
        messages[sessionId] = []
        if let index = chatSessions.firstIndex(where: { $0.id == sessionId }) {
            chatSessions[index].lastMessage = ""
            chatSessions[index].lastUpdated = Date()
            chatSessions[index].messageCount = 0
        }
        saveData()
    }
    
    // MARK: - AI 回覆（可替換為 API）
    func generateAIResponse(for message: String, mode: TherapyMode) -> String {
        // TODO: 未來可改為 API 呼叫
        let lowercaseMessage = message.lowercased()
        switch mode {
        case .chatMode:
            if lowercaseMessage.contains("壓力") {
                return "聽起來您最近壓力不小。能告訴我是什麼讓您感到有壓力嗎？"
            } else if lowercaseMessage.contains("開心") || lowercaseMessage.contains("高興") {
                return "很高興聽到您心情不錯！是有什麼特別的事情讓您開心嗎？"
            } else if lowercaseMessage.contains("累") || lowercaseMessage.contains("疲憊") {
                return "感覺您很疲憊。最近工作或生活節奏是不是比較緊張？"
            } else if lowercaseMessage.contains("週末") || lowercaseMessage.contains("休息") {
                return "聽起來您需要好好休息一下！有什麼特別想做的嗎？戶外活動、看電影，還是其他的興趣愛好？"
            } else if lowercaseMessage.contains("感受不明") {
                return "感受是很重要的信息。能告訴我這種感受在您身體的哪個部位最明顯嗎？"
            } else {
                return "我理解您的感受。能告訴我更多關於這個情況的細節嗎？"
            }
        case .cbtMode:
            if lowercaseMessage.contains("總是") || lowercaseMessage.contains("永遠") {
                return "我注意到您用了「總是」這個詞。讓我們檢視一下這個想法是否準確。能給我一些具體的例子嗎？"
            } else if lowercaseMessage.contains("失敗") || lowercaseMessage.contains("做不好") {
                return "失敗的感受很難受。讓我們分析一下這個想法背後的證據。什麼讓您覺得是失敗？"
            } else if lowercaseMessage.contains("焦慮") || lowercaseMessage.contains("擔心") {
                return "焦慮和擔心是很常見的情緒。讓我們用CBT的方式來分析這些想法，看看哪些是基於事實的。"
            } else {
                return "讓我們用認知行為療法的方式來分析這個問題。首先，我們可以識別一些可能影響您情緒的想法模式。"
            }
        case .mbtMode:
            if lowercaseMessage.contains("不理解") || lowercaseMessage.contains("不懂") {
                return "理解他人的想法確實不容易。讓我們試著從心智化的角度來看，您覺得對方可能在想什麼？"
            } else if lowercaseMessage.contains("感受") || lowercaseMessage.contains("情緒") {
                return "感受是很重要的信息。能告訴我這種感受在您身體的哪個部位最明顯嗎？"
            } else if lowercaseMessage.contains("關係") || lowercaseMessage.contains("人際") {
                return "人際關係是複雜的。讓我們一起探索在這個關係中，您和對方各自的感受和需求。"
            } else if lowercaseMessage.contains("感受不明") {
                return "感受混亂時很正常的。讓我們慢慢來，先試著感受一下您現在身體的狀態，有什麼地方特別緊繃或放鬆嗎？"
            } else {
                return "在正念為基礎的療法中，我們關注當下的感受和體驗。讓我們花一點時間覺察您現在的感受。"
            }
        }
    }
    
    // MARK: - 持久化
    private func saveData() {
        if let sessionsData = try? JSONEncoder().encode(chatSessions) {
            userDefaults.set(sessionsData, forKey: sessionsKey)
        }
        if let messagesData = try? JSONEncoder().encode(messages) {
            userDefaults.set(messagesData, forKey: messagesKey)
        }
    }
    
    private func loadData() {
        if let sessionsData = userDefaults.data(forKey: sessionsKey),
           let sessions = try? JSONDecoder().decode([ChatSession].self, from: sessionsData) {
            chatSessions = sessions
        }
        if let messagesData = userDefaults.data(forKey: messagesKey),
           let loadedMessages = try? JSONDecoder().decode([UUID: [ChatMessage]].self, from: messagesData) {
            messages = loadedMessages
        }
    }
    
    private func createSampleDataIfNeeded() {
        if chatSessions.isEmpty {
            let session = ChatSession(title: "範例對話", therapyMode: .chatMode, tags: ["範例"])
            chatSessions = [session]
            messages[session.id] = [
                ChatMessage(content: "你好！這是一個範例對話。", isFromUser: false, mode: .chatMode)
            ]
            saveData()
        }
    }
    
    private func generateSessionTitle(for mode: TherapyMode) -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        return "\(mode.shortName) - \(formatter.string(from: now))"
    }
} 