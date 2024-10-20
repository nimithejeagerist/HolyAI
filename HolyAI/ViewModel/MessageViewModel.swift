//
//  MessageViewModel.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import Combine
import FirebaseFirestore

final class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private let firestoreManager = FirestoreManager()
    private let openAIService = OpenAIService()
    private var cancellables = Set<AnyCancellable>()
    @Published var count = 0
    
    func fetchMessages(for conversationId: String) {
        firestoreManager.getMessages(for: conversationId) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func sendMessage(content: String, conversationId: String, senderId: String, completion: @escaping () -> Void) {
        let newMessage = Message(
            conversationId: conversationId, 
            content: content,
            senderId: senderId,
            timestamp: Timestamp(date: Date())
        )
        
        firestoreManager.saveMessage(newMessage) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.messages.append(newMessage)
                    self.count += 1
                    completion()
                    self.getBotReply(for: conversationId, senderId: senderId) {
                        self.fetchMessages(for: conversationId)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func getBotReply(for conversationId: String, senderId: String, completion: @escaping () -> Void) {
        self.isLoading = true
        
        let systemMessage = """
        You are a friendly and encouraging Bible assistant named BiblePal.
        Your primary role is to answer questions using the Bible as your source, providing clear references for your answers.
        Always be conversational, empathetic, and supportive in your responses.
        If the Bible does not provide sufficient information, offer kind and encouraging advice like a good friend would, always aiming to uplift and inspire. 
        However, do not tolerate any offensive or inappropriate language, and gently redirect the conversation if such language is used.
        Your focus should remain strictly on topics related to human feelings, future prospects, and Bible-related matters. 
        You must refrain from discussing topics outside of this scope, such as technical advice or other non-spiritual matters.
        If a question falls outside of your area, politely inform the user that you are unable to assist with that request, and steer the conversation back to more suitable topics.
        Your ultimate goal is to reflect the guiding and comforting presence of the Holy Spirit in all interactions.
        You can also have a little humour, nothing cringe, but enough to diffuse tough situations and make people laugh.
        """
        
        openAIService.getBotReply(messages: self.messages, systemMessageContent: systemMessage) { [weak self] response in
            guard let self = self  else { return }
            
            if let response = response {
                let botMessage = Message(
                    conversationId: conversationId,
                    content: response,
                    senderId: "bot",
                    timestamp: Timestamp(date: Date())
                )
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messages.append(botMessage)
                }
                
                self.firestoreManager.saveMessage(botMessage) { result in
                    switch result {
                    case .success:
                        completion()
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Failed to get a response from the bot 😇"
                }
            }
        }
    }
    
}
