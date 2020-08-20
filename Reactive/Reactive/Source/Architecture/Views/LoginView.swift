//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: .zero) {
            stateView
        }
            .onAppear(perform: { self.viewModel.send(event: .onAppear)})
            .navigationBarTitle("Login", displayMode: .inline)
    }

    private var stateView: some View {
        switch viewModel.state {
        case .idle:
            return defaultView.toAnyView()
            
        case .loading:
            return loadingView.toAnyView()
            
        case .error(let error):
            return errorView(error).toAnyView()

        case .navigating(let view):
            return activeRoute(to: view).toAnyView()
        }
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: spacing) {
            ErrorText(error: error)
                .padding(.vertical, spacing)

            defaultView
        }
    }
    
    private var defaultView: some View {
        VStack(spacing: spacing) {
            InputField(placeholder: "Email", text: $email)
            InputField(placeholder: "Password", text: $password, isSecureField: true)

            Button(action: { self.viewModel.send(event: .loginClicked(self.email, self.password)) }) {
                Text("Login")
            }

            Button(action: { self.viewModel.send(event: .signUpClicked) }) {
                Text("Sign Up")
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}