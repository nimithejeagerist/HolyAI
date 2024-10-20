//
//  AddConversationView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI

struct AddConversationView: View {
    @Binding var newConversationTitle: String
    @Binding var showAddConversationPopup: Bool
    var addConversationAction: () -> Void
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    close()
                }
            
            VStack {
                // Adding a bit more padding to the top of the title to accommodate the X button
                Text("Create a Chat")
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                    .padding(.horizontal)
                    .padding(.top, 20) // Adjusted top padding
                    .padding(.bottom, 5)
                    .foregroundStyle(.white)
                
                HStack {
                    Text("Give your conversation a meaningful title to help you keep track of your discussions. Once you’re ready, simply tap the button below to create your new conversation.")
                        .font(Font.custom("Poppins-Medium", size: 13))
                        .padding(.horizontal)
                        .padding(.bottom, 3)
                        .foregroundStyle(.white)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.white)
                    
                    TextField("", text: $newConversationTitle, prompt: Text("New Conversation Title").foregroundStyle(Color.placeholderColor))
                        .font(Font.custom("Poppins-Medium", size: 15))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 10)
                
                Button {
                    if !newConversationTitle.isEmpty {
                        addConversationAction()
                        newConversationTitle = ""
                        showAddConversationPopup = false
                    } else {
                        // Handle empty title error
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.customColorThree)
                        
                        Text("Add Chat")
                            .font(Font.custom("Poppins-Medium", size: 15))
                            .foregroundStyle(Color.customColor)
                            .padding(.vertical, 12)
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.customColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.white)
                        .padding(.top, 20)
                        .padding(.trailing, 25)
                    }
                    Spacer()
                }
            }
            .shadow(radius: 20)
            .padding(20)
        }
        .preferredColorScheme(.light)
    }
    
    func close() {
        withAnimation(.spring()) {
            showAddConversationPopup = false
        }
    }
}

#Preview {
    AddConversationView(newConversationTitle: .constant(""), showAddConversationPopup: .constant(true), addConversationAction: {})
}
