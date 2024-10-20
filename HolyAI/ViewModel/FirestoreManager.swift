//
//  FirestoreManager.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    
    func createConversation(title: String, userId: String, completion: @escaping (Result<Conversation, Error>) -> Void) {
        let conversationId = UUID().uuidString
        let newConversation = Conversation(id: conversationId, title: title, createdAt: Timestamp(date: Date()), userId: userId)
        
        do {
            try db.collection("conversations").document(conversationId).setData(from: newConversation) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newConversation))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getConversations(for userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        db.collection("conversations").whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print(snapshot!)
                let conversations = snapshot?.documents.compactMap { document -> Conversation? in
                    try? document.data(as: Conversation.self)
                } ?? []
                completion(.success(conversations))
            }
        }
    }
    
    func updateConversationTitle(conversationId: String, newTitle:String, completion: @escaping (Result<Void, Error>) -> Void) {
        let conversationRef = db.collection("conversations").document(conversationId)
        conversationRef.updateData(["title": newTitle]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteConversation(conversationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("conversations").document(conversationId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getMessages(for conversationId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        db.collection("messages").whereField("conversationId", isEqualTo: conversationId).order(by: "timestamp").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let messages = snapshot?.documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                } ?? []
                completion(.success(messages))
            }
        }
    }
    
    func saveMessage(_ message: Message, completion: @escaping(Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection("messages").addDocument(from: message) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
}
