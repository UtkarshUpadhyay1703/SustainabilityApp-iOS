//
//  ChatViewModel.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import Foundation
import SwiftUI
import Combine

final class ChatStorage {
    @AppStorage("chat_history_v1") private var rawHistory: String = ""
    
    func save(_ messages: [Message]) {
        do {
            let data = try JSONEncoder().encode(messages)
            rawHistory = data.base64EncodedString()
        } catch {
            print("ChatStorage.save error:", error)
        }
    }
    
    func load() -> [Message] {
        guard !rawHistory.isEmpty,
              let data = Data(base64Encoded: rawHistory) else { return [] }
        do {
            return try JSONDecoder().decode([Message].self, from: data)
        } catch {
            print("ChatStorage.load error:", error)
            return []
        }
    }
}

// MARK: - Service Protocol

protocol ChatServiceProtocol {
    /// Returns a bot reply for given userText. Use async so implementations can call network.
    func getBotReply(for userText: String) async -> String
}

// MARK: - MockChatService (rule-based)

final class MockChatService: ChatServiceProtocol {
    func getBotReply(for userText: String) async -> String {
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let lower = userText.lowercased()
        if lower.contains("co2") || lower.contains("co2e") || lower.contains("carbon") || lower.contains("footprint") {
            return "You can calculate and monitor your personal ecological footprint through the **CARBON FOOTPRINT** activity available on the Homepage. The result will always be visible in your \"profile\" section, and you can recalculate your Carbon footprint each year."
        } else if lower.contains("how") && (lower.contains("start") || lower.contains("begin")) {
            return "Start by visiting Today's activities and tap an action (e.g., Mobility). Complete it to earn XP and increase your streak."
        } else if lower.contains("help") || lower.contains("support") || lower.contains("account") {
            return "If you need account help, go to Profile → Settings or email support@yourapp.com. Would you like me to open Settings?"
        } else if lower.contains("hello") || lower.contains("hi") {
            return "Hello! I'm Ora — ask me anything about the app or sustainability."
        } else if lower.contains("thanks") || lower.contains("thank") {
            return "You’re welcome! Anything else I can help with?"
        } else {
            return "The answer is not present in the knowledge base."
        }
    }
}

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    
    private let service: ChatServiceProtocol
    private let storage = ChatStorage()
    
    init(service: ChatServiceProtocol) {
        self.service = service
        // load persisted messages (if any). If none, seed with a greeting.
        let loaded = storage.load()
        if loaded.isEmpty {
            messages = [
                Message(text: "Hi! I'm Ora — ask me anything about the app or sustainability.", isBot: true, timestamp: Date())
            ]
            storage.save(messages)
        } else {
            messages = loaded
        }
    }
    
    /// Send user message and request bot reply asynchronously
    func send() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Append user message locally and persist immediately for snappy UI
        let userMessage = Message(text: trimmed, isBot: false, timestamp: Date())
        messages.append(userMessage)
        storage.save(messages)
        inputText = ""
        
        // ask service for reply
        Task {
            await requestBotReply(for: trimmed)
        }
    }
    
    private func requestBotReply(for text: String) async {
        isTyping = true
        // get reply from service (async)
        let reply = await service.getBotReply(for: text)
        // optional small extra delay to make it feel natural
        try? await Task.sleep(nanoseconds: 250_000_000)
        let botMessage = Message(text: reply, isBot: true, timestamp: Date())
        messages.append(botMessage)
        isTyping = false
        storage.save(messages)
    }
    
    /// Clear history (for debug)
    func clearHistory() {
        messages.removeAll()
        storage.save(messages)
    }
}
