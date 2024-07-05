//
//  LoginView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct LoginView: View {
    
    
    // MARK: - Properties
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            mainVStack
            loginButton
            Spacer()
            registrationLink
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        
    }
    
    
    // MARK: - View Components
    
    private var mainVStack: some View {
        VStack(spacing: 24) {
            Text("Login")
                .font(.system(size: 24))
                .fontWeight(.semibold)
            
            TextFieldView(text: $email,
                          title: "Email Address",
                          placeholder: "name@gmail.com")
            .textInputAutocapitalization(.never)
            
            TextFieldView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
            
            forgotPasswordView
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    private var forgotPasswordView: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text("Forgot Password?")
                .fontWeight(.bold)
                .font(.footnote)
                .foregroundStyle(.blue)
        }
    }
    
    
    private var loginButton: some View {
        VStack(spacing: 20) {
            Button {
            //  viewModel.login(email: email, password: password, completion: {_ in}, navigationManager: navigationManager)
               navigationManager.currentDestination = .mainView
            } label: {
                PrimaryButtonView(
                    text: "Log In",
                    textColor: .white,
                    backgroundColor: .main
                )
            }
        }
    }
    private var registrationLink: some View {
        Button {
            navigationManager.currentDestination = .registerView
        } label: {
            HStack(spacing: 2) {
                Text("Don't have an account? ")
                Text("Sign Up")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
        }
    }
}
#Preview {
    LoginView()
        .environmentObject(NavigationManager())
}
