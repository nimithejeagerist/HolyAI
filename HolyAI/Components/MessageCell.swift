//
//  MessageCell.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI
import FirebaseFirestore

struct MessageCell: View {
    var message: Message
    var isUserMessage: Bool

    var body: some View {
        HStack {
            if isUserMessage {
                Spacer()
                
                Text(message.content)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .padding()
                    .background(Color.messageColor.opacity(0.5))
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                
                
            } else {
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .stroke(Color.customColor.opacity(0.7), lineWidth: 3)
                            .clipShape(Circle())
                            .frame(width: 32, height: 32)
                        
                        Image(.holyAILogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28 , height: 28)
                    }
                    .padding(.trailing, 4)
                    
                    Text(message.content)
                        .font(Font.custom("Poppins-Regular", size: 16))
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 10) {
        MessageCell(
            message: Message(
                id: "1",
                conversationId: "exampleConversationId",
                content: "Hey",
                senderId: "user123",
                timestamp: Timestamp()
            ),
            isUserMessage: true
        )
        MessageCell(
            message: Message(
                id: "2",
                conversationId: "exampleConversationId",
                content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce facilisis efficitur vestibulum. Phasellus consequat iaculis interdum. Maecenas consectetur condimentum enim ac pretium. Cras id consectetur libero, eu tempus orci. Vivamus commodo erat purus, quis tempus felis porttitor mattis. Integer lectus quam, viverra id dui eu, feugiat rhoncus sapien",
                senderId: "bot123",
                timestamp: Timestamp()
            ),
            isUserMessage: false
        )
    }
    .background(Color.customColorThree)
}
