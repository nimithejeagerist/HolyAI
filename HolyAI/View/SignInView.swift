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
    static let messageColor = Color(red: 0.64, green: 0.72, blue: 0.91)
}

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @FocusState private var isFocus: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.customColorThree
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 295, height: 300)
                
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
                            .padding(.horizontal, 7)
                        TextField("", text: $email, prompt: Text("Enter your email").foregroundStyle(Color.placeholderColor))
                            .font(Font.custom("Poppins-Medium", size: 16))
                            .foregroundStyle(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
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
                            .padding(.horizontal, 10)
                        SecureField("", text: $password, prompt: Text("Enter your password").foregroundStyle(Color.placeholderColor))
                            .font(Font.custom("Poppins-Medium", size: 16))
                            .foregroundStyle(.black)
                            .disableAutocorrection(true)
                            .padding()
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
                    Task {
                        do {
                            let result = try await authViewModel.signIn(email: email, password: password)
                            if result != nil {
                                showAlert(message: result ?? "")
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    Text("Log In")
                        .font(Font.custom("Poppins-SemiBold", size: 22))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.customColor)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 20)
                .shadow(color: .black, radius: 3)
                
                Spacer()
                
                NavigationLink(destination: SignUpView().environmentObject(authViewModel)) {
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
