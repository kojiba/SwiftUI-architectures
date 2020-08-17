//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var isPreview = false
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isLoading = false
    @State private var error = ""

    @State private var navigatingSignUp = false
    @State private var navigatingHome = false

    private let network = Network.shared

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {

            ErrorText(error: error)
                .padding(.vertical, spacing)

            if isLoading {
                loadingView
            } else {
                defaultView
            }

            NavigationLink(destination: PostsView(tags: ["Login", "Tag", "1"], goingLogin: $navigatingHome), isActive: $navigatingHome) {
                EmptyView()
            }
                .isDetailLink(false)

            NavigationLink(destination: EditBasicInfoView(), isActive: $navigatingSignUp) {
                EmptyView()
            }
        }
            .navigationBarTitle("Login", displayMode: .inline)
    }
    
    private var defaultView: some View {
        VStack(spacing: spacing) {
            InputField(placeholder: "Email", text: $email)
            InputField(placeholder: "Password", text: $password, isSecureField: true)

            Button(action: loginButtonClicked) {
                Text("Login")
            }

            Button(action: signUpClicked) {
                Text("Sign Up")
            }
        }
    }

    /// Actions

    private func loginButtonClicked() {
        error = validate()
        if !error.isEmpty {
            return
        }
        
        if isPreview {
            navigatingHome = true
            return
        }

        isLoading = true
        
        network.login(email: email, password: password) { result in
            self.isLoading = false
            
            self.clearCreds()
            self.navigatingHome = result
        }
    }

    private func signUpClicked() {
        navigatingSignUp = true
    }

    /// Logic

    private func clearCreds() {
        self.email = ""
        self.password = ""
    }

    private func validate() -> String {
        if email.isEmpty {
            return "Email is empty"
        }
        if password.isEmpty {
            return "Password is empty"
        }
        
        return ""
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isPreview: true)
    }
}