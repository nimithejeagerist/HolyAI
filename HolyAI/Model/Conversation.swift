//
//  Conversation.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var createdAt: Timestamp
    var userId: String
}
