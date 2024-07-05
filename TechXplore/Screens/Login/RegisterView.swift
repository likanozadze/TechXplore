//
//  RegisterView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: - Properties
    @State private var personalNumber = ""
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var containsCapitalLetter = false
    @State private var containsNumber = false
    @State private var containsSymbol = false
    @State private var isValidSize = false
    @State private var isValidEmail = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    
    // MARK: - Body
    var body: some View {
        VStack {
            signUpText
            inputFields
            conditionsVStack
            registerButton
            Spacer()
            signInButton
        }
    }
    
    // MARK: - View Components
    private var signUpText: some View {
        Text("Sign Up")
            .font(.system(size: 26))
            .fontWeight(.semibold)
    }
    
    private var inputFields: some View {
        VStack(spacing: 24) {
            
            TextFieldView(text: $firstName,
                          title: "Personal Number",
                          placeholder: "Enter your personal number")
            
            TextFieldView(text: $email,
                          title: "Email Address",
                          placeholder: "name@gmail.com")
            .textInputAutocapitalization(.never)
            .onChange(of: email) { _, _ in
                validateEmail()
            }
            
            TextFieldView(text: $firstName,
                          title: "First Name",
                          placeholder: "Enter your name")
            
            TextFieldView(text: $lastName,
                          title: "Last Name",
                          placeholder: "Enter your last name")
            
            TextFieldView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
            .onChange(of: password) { _, _ in
                validatePassword()
            }
            
            confirmPasswordField
        }
        .padding(.horizontal)
        .padding(.top, 2)
    }
    
    private var confirmPasswordField: some View {
        ZStack(alignment: .trailing) {
            TextFieldView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true)
            
            if !password.isEmpty && !confirmPassword.isEmpty {
                if password == confirmPassword {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.systemRed))
                }
            }
        }
    }
    
    private var conditionsVStack: some View {
        VStack(alignment: .leading) {
            Group {
                PasswordView(condition: isValidEmail, text: "Email contains symbol \"@\"")
                PasswordView(condition: containsCapitalLetter, text: "At least one uppercase letter")
                PasswordView(condition: containsSymbol, text: "At least one special symbol: \"@, #, $, %, &\"")
                PasswordView(condition: isValidSize, text: "At least 8 characters in length")
                PasswordView(condition: containsNumber, text: "At least one digit")
            }
        }
        .padding(.top, 10)
        .font(.system(size: 15))
    }
    
    private var registerButton: some View {
        VStack(spacing: 20) {
            Button {
                
            } label: {
                PrimaryButtonView(
                    text: "Register",
                    textColor: .white,
                    backgroundColor: .main
                )
            }
        }
    }
    private var signInButton: some View {
        Button {
            navigationManager.currentDestination = .loginView
            dismiss()
        } label: {
            HStack(spacing: 2) {
                Text("Have an account?")
                Text("Sign In")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
        }
    }
    
    
    func validatePassword() {
        containsCapitalLetter = password.range(of: "[A-Z]", options: .regularExpression) != nil
        containsNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        containsSymbol = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        isValidSize = password.count >= 8
    }
    
    func validateEmail() {
        isValidEmail = email.contains("@")
    }
}


#Preview {
    RegisterView()
}
