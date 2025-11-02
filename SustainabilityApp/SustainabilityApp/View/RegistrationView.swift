//
//  RegistrationView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import SwiftUI
import SwiftKeychainWrapper

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var showDashboard: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.0, green: 0.4, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.8, blue: 1, alpha: 1))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text("Create Account")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.blue)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button {
                    KeychainWrapper.standard.set(email, forKey: "userEmail")
                    KeychainWrapper.standard.set(password, forKey: "userPassword")
                    email = ""
                    password = ""
                    withAnimation {
                        dismiss()
                        showDashboard = true
                    }
                } label: {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var val = false
    RegistrationView(showDashboard: $val)
}
