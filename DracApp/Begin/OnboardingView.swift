//
//  OnboardingView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isNameEmpty: Bool = false
    @State private var isEmailEmpty: Bool = false

    var body: some View {
        VStack {
            Text("Drac")
                .font(.largeTitle)
                .padding()

            Text("Please enter your information to get started.")
                .padding()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if isNameEmpty || isEmailEmpty {
                Text("Both fields are required.")
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Sign Up") {
                if name.isEmpty {
                    isNameEmpty = true
                } else {
                    isNameEmpty = false
                }
                
                if email.isEmpty {
                    isEmailEmpty = true
                } else {
                    isEmailEmpty = false
                }
                
                if !name.isEmpty && !email.isEmpty {
                    // Save user information and set first launch flag to false
                    UserDefaults.standard.set(true, forKey: "isUserInfoSaved")
                    UserDefaults.standard.set(name, forKey: "userName")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    isFirstLaunch = false
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}
