//
//  LoginView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 01/11/25.
//


import SwiftUI
import SwiftKeychainWrapper

struct LoginView: View {
    @State private var email: String = ""
    @State private var showDashboard = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                // MARK: - Top Logo and Language
                HStack {
                    Image("SHR_logo") // replace with your app logo asset
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 60)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Image("britishFlag") // replace with your flag image
                        .resizable()
                        .frame(width: 32, height: 22)
                        .clipShape(Rectangle())
                        .padding(.trailing)
                }
                .padding(.top, 12)
                
                // MARK: - Social Logins
                VStack(spacing: 16) {
                    LoginButton(icon: "applelogo", title: "Log in with Apple", color: .black)
                    LoginButton(icon: "googleLogo", title: "Log in with Google", color: Color(red: 0.93, green: 0.24, blue: 0.21))
                    LoginButton(icon: "facebookLogo", title: "Log in with Facebook", color: Color(red: 0.23, green: 0.35, blue: 0.60))
                }
                
                Divider()
                    .padding(.horizontal, 40)
                
                // MARK: - Email Section
                VStack(spacing: 12) {
                    Text("Sign in with Email")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    TextField("  Enter your email address", text: $email)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 40)
                    
                    Button {
                        withAnimation {
                            if email == KeychainWrapper.standard.string(forKey: "userEmail") {
                                email = ""
                                showDashboard = true
                            } else {
                                showAlert = true
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                                .bold()
                            Text("Sign in with Email")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 40)
                    }
                }
                
                // MARK: - SSO Section
                VStack(spacing: 12) {
                    Text("Do you work for an organization that uses SSO?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    LoginButton(icon: "lock", title: "Log in with SSO", color: Color.purple)
                }
                
                // MARK: - Registration
                NavigationLink(destination: RegistrationView(showDashboard: $showDashboard)) {
                    Spacer()
                    HStack {
                        Text("Go to Registration")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(Color.blue)
                    .bold()
                    .padding()
                    Spacer()
                }
                .padding()
                .background(.white)
                .clipShape(Capsule())
            }
            .padding(20)
            .background(Color(#colorLiteral(red: 0.964, green: 0.974, blue: 0.986, alpha: 1)).edgesIgnoringSafeArea(.all))
            .alert("Error", isPresented: $showAlert, actions: {
                Button {
                    email = ""
                    showAlert = false
                } label: {
                    Text("Cancel")
                }
            }, message: {
                Text("Please enter correct Email Id or Register first!")
            })
            .fullScreenCover(isPresented: $showDashboard) {
                DashboardView(showDashboard: $showDashboard) // navigate to main dashboard after login
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Login Button Reusable View
struct LoginButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // handle tap
        }) {
            HStack {
                Spacer()
                if icon.hasSuffix("Logo") {
                    Image(icon)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                Text(title)
                    .fontWeight(.semibold)
                    .padding(.leading, 6)
                Spacer()
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    LoginView()
}
