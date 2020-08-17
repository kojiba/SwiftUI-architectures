//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct LoginView<ViewModel: LoginViewModelProtocol>: View {
    @ObservedObject var model: ViewModel

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {

            ErrorText(error: model.error)
                .padding(.vertical, spacing)

            if model.isLoading {
                loadingView
            } else {
                defaultView
            }
        }
            .navigationBarTitle("Login", displayMode: .inline)
    }
    
    private var defaultView: some View {
        VStack(spacing: spacing) {
            InputField(placeholder: "Email", text: $model.email)
            InputField(placeholder: "Password", text: $model.password, isSecureField: true)

            Button(action: model.loginButtonClicked) {
                Text("Login")
            }

            Button(action: model.signUpClicked) {
                Text("Sign Up")
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(model: LoginViewModelMock())
    }
}