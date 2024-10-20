//
//  UpdateConversationView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-08-21.
//

import SwiftUI

struct EditConversationView: View {
    @Binding var newConversationTitle: String
    @Binding var showEditConversationPopup: Bool
    var onSave: () -> Void
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
                Text("Edit title")
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                    .padding(.horizontal)
                    .padding(.top, 20) // Adjusted top padding
                    .padding(.bottom, 5)
                    .foregroundStyle(.white)
                
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
                
                HStack {
                    Button {
                        if !newConversationTitle.isEmpty {
                            onSave()
                            newConversationTitle = ""
                            showEditConversationPopup = false
                        } else {
                            // Handle empty title error
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.customColorThree)
                            
                            Text("Save")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundStyle(Color.customColor)
                                .padding(.vertical, 12)
                        }
                    }
                    
                    Button {
                        close()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.customColorThree)
                            
                            Text("Cancel")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundStyle(Color.customColor)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.customColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .padding(20)
        }
        .preferredColorScheme(.light)
    }
    
    func close() {
        withAnimation(.spring()) {
            showEditConversationPopup = false
        }
    }
}


#Preview {
    EditConversationView(newConversationTitle: .constant(""), showEditConversationPopup: .constant(true), onSave: {})
}
