//
//  Message.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var conversationId: String
    var content: String
    var senderId: String
    var timestamp: Timestamp
}
