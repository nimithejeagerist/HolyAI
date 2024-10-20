//
//  SettingsView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-28.
//

import SwiftUI

struct SettingsView: View {
    @State private var showDeleteConfirmation = false
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var showUpdatePasswordPopup: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customColorThree
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack (alignment: .leading) {
                    Text("Account Management")
                        .font(Font.custom("Poppins-SemiBold", size: 19))
                    
                    Button(action: {
                        authViewModel.signOut()
                        dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .foregroundStyle(Color.customColor)
                            
                            Text("Sign Out")
                                .font(Font.custom("Poppins-Medium", size: 17))
                                .foregroundStyle(.black)
                                .padding(.vertical, 5)
                        }
                    })
                    
                    Divider()
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(Color.customColor)
                                .padding(.bottom, 6)
                        }
                        
                        Text("Delete Account")
                            .font(Font.custom("Poppins-Medium", size: 17))
                            .foregroundStyle(.black)
                            .padding(.bottom, 5)
                            .padding(.leading, 5)
                    })
                    
                    Divider()
                    
                    Button(action: {
                        showUpdatePasswordPopup = true
                    }, label: {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(Color.customColor)
                                .padding(.top, 1)
                        }
                        
                        Text("Change Password")
                            .font(Font.custom("Poppins-Medium", size: 17))
                            .foregroundStyle(.black)
                            .padding(.bottom, 4)
                            .padding(.leading, 5)
                        
                    })
                    
                    Image(.comingSoon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .padding(.top, 50)
                }
                .padding()
                .padding(.top, 15)
                .padding(.leading, 10)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(Font.custom("Poppins-SemiBold", size: 18))
                        .foregroundStyle(Color.customColor)
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(title: Text("Delete Account"),
                      message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                      primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            try await authViewModel.deleteUser()
                            dismiss()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                      secondaryButton: .cancel())
            }
            
            if showUpdatePasswordPopup {
                UpdatePasswordView(oldPassword: $oldPassword, newPassword: $newPassword, showUpdatePasswordPopup: $showUpdatePasswordPopup) { oldPassword, newPassword in
                    Task {
                        do {
                            let success = try await authViewModel.reauthenticateAndChangePassword(oldPassword: oldPassword, newPassword: newPassword)
                            if success == "success" {
                                print("Password updated successfully")
                                dismiss()
                            } else {
                                print("Failed to update password")
                            }
                        } catch {
                            print("Error updating password: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
