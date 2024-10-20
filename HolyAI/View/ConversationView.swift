//
//  ConversationView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct ConversationView: View {
    @StateObject private var conversationViewModel = ConversationViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newConversationTitle: String = ""
    @State private var userId: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAddConversationPopup: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var selectedIndexSet: IndexSet?
    @State private var showEditConversationPopup: Bool = false
    @State private var selectedConversation: Conversation?

    var body: some View {
        ZStack {
            Color.customColorThree
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(conversationViewModel.conversations) { conversation in
                            NavigationLink(destination: MessageView(conversationId: conversation.id!, senderId: userId)) {
                                ConversationCell(conversation: conversation)
                                    .contextMenu {
                                        Button(action: {
                                            selectedConversation = conversation
                                            showEditConversationPopup = true
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }

                                        Button(role: .destructive) {
                                            deleteConversation(conversation: conversation)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        
                        if conversationViewModel.isLoading {
                            VStack(alignment: .center) {
                                LoadingIndicator(animation: .circleBars, color: .customColor, size: .large, speed: .normal)
                            }
                            .padding()
                        }
                    }
                    .padding(.vertical, 7)
                    .frame(maxHeight: .infinity)
                }
                .onAppear {
                    fetchAuthenticatedUser()
                }
                .navigationBarTitle("", displayMode: .inline) 
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showSettingsView = true
                        }, label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(Color.customColor)
                                .padding(.leading, 5)
                        })
                    }
                    ToolbarItem(placement: .principal) {
                        Text("History")
                            .font(Font.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Color.customColor)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showAddConversationPopup = true
                        }, label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(Color.customColor)
                                .padding(.trailing, 5)
                        })
                    }
                }
                .sheet(isPresented: $showSettingsView) {
                    SettingsView()
                        .environmentObject(authViewModel)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Confirmation"),
                        message: Text(alertMessage),
                        primaryButton: .destructive(Text("Delete")) {
                            if let indexSet = selectedIndexSet {
                                deleteItems(at: indexSet)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            if showAddConversationPopup {
                AddConversationView(newConversationTitle: $newConversationTitle, showAddConversationPopup: $showAddConversationPopup) {
                    conversationViewModel.addConversation(title: newConversationTitle, userId: userId)
                }
            }
            
            if showEditConversationPopup {
                EditConversationView(newConversationTitle: $newConversationTitle, showEditConversationPopup: $showEditConversationPopup) {
                    if let selectedConversation = selectedConversation {
                        conversationViewModel.updateConversationTitle(conversationId: selectedConversation.id!, newTitle: newConversationTitle)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func fetchAuthenticatedUser() {
        do {
            let user = try authViewModel.fetchUserId()
            userId = user.uid
            conversationViewModel.fetchConversations(for: user.uid)
        } catch {
            showAlert(message: "Failed to get authenticated user: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func deleteItems(at offsets: IndexSet) {
        selectedIndexSet = offsets
        let confirmationMessage = "Are you sure you want to delete this conversation?"
        showAlert(message: confirmationMessage)
    }
    
    private func deleteConversation(conversation: Conversation) {
        conversationViewModel.deleteConversation(conversationId: conversation.id!)
    }
}


#Preview {
    NavigationStack {
        ConversationView()
            .environmentObject(AuthViewModel())
    }
}
