//
//  AuthViewModel.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: AuthDataResultModel?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    private func getCurrentUser() throws -> FirebaseAuth.User {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return user
    }
    
    func fetchUserId() throws -> AuthDataResultModel {
        let user = try getCurrentUser()
        
        return AuthDataResultModel(user: user)
    }
    
    func getAuthenticatedUser() throws {
        let user = try getCurrentUser()
        self.userSession = user
    }
    
    func createUser(email: String, password: String) async throws -> String? {
        guard !email.isEmpty, !password.isEmpty else {
            return "Email and password must not be empty"
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            try await authResult.user.sendEmailVerification()
            
            if await verifyEmail() {
                self.userSession = authResult.user
                return nil
            } else {
                try await deleteUser()
                return "Please verify your email to complete the sign-up process"
            }
        } catch {
            return error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async throws -> String? {
        guard !email.isEmpty, !password.isEmpty else {
            return "Email and password must not be empty"
        }
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = authResult.user
            return nil
        } catch {
            return error.localizedDescription
        }
    }
    
    // Update password in Firebase
    func reauthenticateAndChangePassword(oldPassword: String, newPassword: String) async throws -> String? {
        guard let user = Auth.auth().currentUser, let email = user.email else { return "User not signed in" }
                
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        do {
            // Reauthenticate the user
            try await user.reauthenticate(with: credential)
            print("Reauthentication successful")
            
            try await user.updatePassword(to: newPassword)
            print("Password updated successfully")
    
            return "success"
        } catch {
            print("Reauthentication failed: \(error.localizedDescription)")
            return error.localizedDescription
        }
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await user.delete()
        self.userSession = nil
        self.currentUser = nil
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func isEmailVerified() async -> Bool {
        guard let user = Auth.auth().currentUser else { return false}
        try? await user.reload()
        return user.isEmailVerified
    }
    
    private func verifyEmail() async -> Bool {
        for _ in 1...120 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if await isEmailVerified() {
                return true
            }
        }
        return false
    }
}
