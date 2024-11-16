//
//  SignInView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI
import UIKit

extension Color {
    static let customColor = Color(red: 0.25, green: 0.41, blue: 0.88)
    static let customColorTwo = Color(red: 0.49, green: 0.24, blue: 0.60)
    static let customColorThree = Color(red: 0.94, green: 0.95, blue: 0.96)
    static let placeholderColor = Color(red: 0.54, green: 0.54, blue: 0.54)
    static let messageColor = Color(red: 0.82, green: 0.89, blue: 1.00)
}

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @FocusState private var isFocus: Bool
    @EnvironmentObject var authVM: AuthViewModel
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
                    Text("Sign in,")
                        .font(Font.custom("Poppins-SemiBold", size: 26))
                        .foregroundStyle(Color.customColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Find wisdom...")
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
                        .foregroundColor(Color.customColor)
                        .transition(.opacity)
                        .padding(.top, 5)
                }
                
                Button(action: {
                    trigger.toggle()
                    Task {
                        do {
                            let result = try await authVM.signIn(email: email, password: password)
                            if result != nil {
                                showAlert(message: result ?? "")
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    Text("Log In")
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
                
                NavigationLink(destination: SignUpView().environmentObject(authVM)) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .font(Font.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(Color.customColor)
                        Text("Sign up")
                            .font(Font.custom("Poppins-Bold", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.customColor)
                    }
                }
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
        SignInView()
            .environmentObject(AuthViewModel())
    }
}
