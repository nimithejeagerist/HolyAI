//
//  ConversationCellViewModel.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-08-28.
//

import Foundation
import FirebaseFirestore

class ConversationCellViewModel: ObservableObject {
    @Published var lastMessage: String = "No messages yet"
    
    private let db = Firestore.firestore()
    
    func fetchLastMessage(for conversationId: String) {
        db.collection("messages")
            .whereField("conversationId", isEqualTo: conversationId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching last message: \(error)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    self.lastMessage = document.get("content") as? String ?? "No message content"
                } else {
                    self.lastMessage = "No messages yet"
                }
            }
    }
}
