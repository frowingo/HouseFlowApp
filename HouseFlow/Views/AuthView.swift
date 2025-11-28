import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 8) {
                Text("Welcome to HouseFlow")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Sign in to manage your shared home")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            // Form
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        appViewModel.authenticate()
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .scaleEffect(0.98)
                .animation(.easeInOut(duration: 0.1), value: false)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        appViewModel.authenticate()
                    }
                }) {
                    Text("Continue as Demo User")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                }
                .scaleEffect(0.98)
                .animation(.easeInOut(duration: 0.1), value: false)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AuthView()
        .environmentObject(AppViewModel())
}
