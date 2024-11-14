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
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    @State private var newMessageContent: String = ""
    @State var emptyScrollToString = "Empty"
    @State private var trigger: Bool = false
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
                    .onChange(of: keyboardObserver.keyboardHeight) { height in
                        if height > 0 {
                            withAnimation {
                                proxy.scrollTo(emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                    
                    
                    // Button and TextField are inside this closure
                    HStack {
                        TextField("", text: $newMessageContent, prompt: Text("Message Holy AI").foregroundStyle(Color.placeholderColor) , axis: .vertical)
                            .font(Font.custom("Poppins-Regular", size: 16))
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
                            trigger.toggle()
                            let messageContent = newMessageContent.trimmingCharacters(in: .whitespaces)
                            
                            if !newMessageContent.isEmpty {
                                newMessageContent = ""
                                sendMessageAndScroll(proxy: proxy, content: messageContent)
                            }
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 33))
                                .foregroundStyle(newMessageContent.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.customColor)
                        }
                        .padding(.trailing, 10)
                        .sensoryFeedback(
                            .impact(weight: .medium, intensity: 0.8),
                            trigger: trigger
                        )
                        .disabled(newMessageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                }
            }
            .animation(.easeOut(duration: 0.3), value: keyboardObserver.keyboardHeight)
        }
        .preferredColorScheme(.light)
        .onTapGesture {
            isFocus = false
        }
    }
    
    private func sendMessageAndScroll(proxy: ScrollViewProxy, content: String) {
        messageViewModel.sendMessage(content: content, conversationId: conversationId, senderId: senderId) {
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(emptyScrollToString, anchor: .bottom)
                }
                newMessageContent = ""
            }
        }
    }
}

#Preview {
    MessageView(conversationId: "exampleConversationId", senderId: "exampleSenderId")
}
