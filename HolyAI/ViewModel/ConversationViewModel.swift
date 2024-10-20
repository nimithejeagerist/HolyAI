//
//  ConversationViewModel.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import Combine

final class ConversationViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private let firestoreManager = FirestoreManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchConversations(for userId: String) {
        isLoading = true
        firestoreManager.getConversations(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let conversations):
                    self!.isLoading = false
                    self?.conversations = conversations
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addConversation(title: String, userId: String) {
        firestoreManager.createConversation(title: title, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let conversation):
                    self?.conversations.append(conversation)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateConversationTitle(conversationId: String, newTitle: String) {
        firestoreManager.updateConversationTitle(conversationId: conversationId, newTitle: newTitle) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.conversations.firstIndex(where: { $0.id == conversationId }) {
                        self?.conversations[index].title = newTitle
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteConversation(conversationId: String) {
        firestoreManager.deleteConversation(conversationId: conversationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.conversations.removeAll() { $0.id == conversationId}
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    
}
