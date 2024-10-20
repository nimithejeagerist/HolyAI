//
//  ConversationCell.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI
import FirebaseFirestore

struct ConversationCell: View {
    var conversation: Conversation
    @StateObject private var conversationCellViewModel = ConversationCellViewModel()
    
    var body: some View {
        HStack {
            Image(.speechBubble)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .padding(.horizontal, 13)
            VStack(alignment: .leading, content: {
                Text(conversation.title)
                    .font(Font.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.black)
                Text(conversationCellViewModel.lastMessage)
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
            })
            Spacer()
        }
        .padding(.vertical, 7)
        .background(Color.customColorThree)
        .cornerRadius(10)
        .padding(.horizontal)
        .onAppear {
            conversationCellViewModel.fetchLastMessage(for: conversation.id!)
        }
        
    }
}

#Preview {
    ConversationCell(conversation: Conversation(id: "1", title: "Sample Conversation", createdAt: Timestamp(), userId: "user123"))
}
