import SwiftUI

struct UpdatePasswordView: View {
    @Binding var oldPassword: String
    @Binding var newPassword: String
    @Binding var showUpdatePasswordPopup: Bool
    var onUpdate: (String, String) async -> Void
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
                Text("Update password")
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .foregroundStyle(.white)
                
                // Old Password Field
                passwordField(text: $oldPassword, placeholder: "Enter your old password")
                
                // New Password Field
                passwordField(text: $newPassword, placeholder: "Enter your new password")
                
                HStack {
                    actionButton(text: "Save", action: {
                        let currentPassword = oldPassword
                        let passwordToUpdate = newPassword
                        
                        if !currentPassword.isEmpty && !passwordToUpdate.isEmpty {
                            Task {
                                await onUpdate(currentPassword, passwordToUpdate)
                            }
                            newPassword = ""
                            showUpdatePasswordPopup = false
                        } else {
                            // Handle empty title error
                        }
                    })
                    
                    actionButton(text: "Cancel", action: close)
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
    
    // Helper function for password fields
    @ViewBuilder
    private func passwordField(text: Binding<String>, placeholder: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
            
            SecureField("", text: text, prompt: Text(placeholder).foregroundStyle(Color.placeholderColor))
                .font(Font.custom("Poppins-Medium", size: 15))
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .cornerRadius(10)
        }
        .padding(.horizontal, 10)
    }
    
    // Helper function for action buttons
    @ViewBuilder
    private func actionButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.customColorThree)
                
                Text(text)
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundStyle(Color.customColor)
                    .padding(.vertical, 12)
            }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            showUpdatePasswordPopup = false
        }
    }
}

#Preview {
    UpdatePasswordView(
        oldPassword: .constant(""),
        newPassword: .constant(""),
        showUpdatePasswordPopup: .constant(true),
        onUpdate: { oldPassword, newPassword in
            print("Password to update in preview: \(oldPassword), \(newPassword)")
        }
    )
}
