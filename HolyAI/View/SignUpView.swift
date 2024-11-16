//
//  SignUpView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI
import UIKit

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @FocusState private var isFocus: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject  var authVM: AuthViewModel
    @State private var trigger: Bool = false
    
    var body: some View {
        ZStack {
            Color.customColorThree
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(.holyAILogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280)
                
                VStack(alignment: .leading) {
                    Text("Create an account,")
                        .font(Font.custom("Poppins-SemiBold", size: 26))
                        .foregroundStyle(Color.customColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Grow your faith!")
                        .font(Font.custom("Poppins-SemiBold", size: 26))
                        .foregroundStyle(Color.customColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 30)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color.customColor)
                            .padding(.leading, 7)
                            .padding(.trailing, 3)
                        TextField("", text: $email, prompt: Text("Enter your email").foregroundStyle(Color.placeholderColor))
                            .font(Font.custom("Poppins-Medium", size: 16))
                            .foregroundStyle(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.vertical)
                            .focused($isFocus)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customColor, lineWidth: 2)
                    )
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color.customColor)
                            .padding(.leading, 10)
                            .padding(.trailing, 8)
                        SecureField("", text: $password, prompt: Text("Enter your password").foregroundStyle(Color.placeholderColor))
                            .font(Font.custom("Poppins-Medium", size: 16))
                            .foregroundStyle(.black)
                            .disableAutocorrection(true)
                            .padding(.vertical)
                            .focused($isFocus)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customColor, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 30)
                
                if showAlert {
                    Text(alertMessage)
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(.red)
                        .transition(.opacity)
                        .padding(.top, 5)
                }
                
                Button(action: {
                    trigger.toggle()
                    Task  {
                        do {
                            let result = try await authVM.createUser(email: email, password: password)
                            
                            if result != nil {
                                showAlert(message: result ?? "")
                            } else {
                                dismiss()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) { Text("Sign Up")
                        .font(Font.custom("Poppins-Medium", size: 21))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.customColor)
                        .cornerRadius(20)
                        .padding(.horizontal, 50)
                }
                .padding(.top, 15)
                .padding(.horizontal)
                .shadow(color: .black, radius: 2)
                .sensoryFeedback(
                    .impact(weight: .medium, intensity: 0.5),
                    trigger: trigger
                )
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .font(Font.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(Color.customColor)
                        Text("Sign In.")
                            .font(Font.custom("Poppins-Bold", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.customColor)
                    }
                }
                .navigationBarBackButtonHidden()
                .padding(.bottom, 50)
            }
        }
        .onTapGesture {
            isFocus = false
        }
        .preferredColorScheme(.light)
    }
    
    private func showAlert(message: String) {
        withAnimation {
            alertMessage = message
            showAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showAlert = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
