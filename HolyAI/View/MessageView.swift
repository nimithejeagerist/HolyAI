//
//  MessageView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-28.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct MessageView: View {
    @StateObject private var messageViewModel = MessageViewModel()
    @State private var newMessageContent: String = ""
    @State var emptyScrollToString = "Empty"
    
    @FocusState private var isFocus: Bool
    var conversationId: String
    var senderId: String
    
    var body: some View {
        ZStack {
            Color.customColorThree
                .ignoresSafeArea()
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(messageViewModel.messages) { message in
                                MessageCell(message: message, isUserMessage: message.senderId == senderId)
                                    .padding(.horizontal)
                                    .id(message.id)
                            }
                            
                            if messageViewModel.isLoading {
                                HStack {
                                    LoadingIndicator(animation: .threeBallsBouncing, color: Color.customColor, size: .small, speed: .fast)
                                    Spacer()
                                }
                                .padding(.leading, 37)
                                .padding(.bottom, 10)
                                .transition(.opacity)
                                .background(Color.customColorThree)
                            }
                            
                            HStack{Spacer()}
                                .id(emptyScrollToString)
                        }
                        .onReceive(messageViewModel.$count, perform: { _ in
                            proxy.scrollTo(emptyScrollToString, anchor: .bottom)
                        })
                    }
                    .onAppear {
                        messageViewModel.fetchMessages(for: conversationId)
                    }
                    .onChange(of: messageViewModel.messages) { oldMessages, newMessages in
                        if let lastMessageId = newMessages.last?.id {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                            newMessageContent = ""
                        }
                    }
                    
                    
                    
                    // Button and TextField are inside this closure
                    HStack {
                        TextField("", text: $newMessageContent, prompt: Text("Message Holy AI").foregroundStyle(Color.placeholderColor) , axis: .vertical)
                            .font(Font.custom("Poppins-Medium", size: 15))
                            .lineLimit(1...5)
                            .padding(7)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.customColor, lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .focused($isFocus)
                        
                        Button {
                            if !newMessageContent.isEmpty {
                                sendMessageAndScroll(proxy: proxy)
                            }
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 33))
                                .foregroundStyle(Color.customColor)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                }
            }
        }
        .preferredColorScheme(.light)
        .onTapGesture {
            isFocus = false
        }
    }
    
    private func sendMessageAndScroll(proxy: ScrollViewProxy) {
        messageViewModel.sendMessage(content: newMessageContent, conversationId: conversationId, senderId: senderId) {
            newMessageContent = ""
        }
    }
}

#Preview {
    MessageView(conversationId: "exampleConversationId", senderId: "exampleSenderId")
}
