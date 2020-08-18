//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct CreatePasswordView: View {
    @State var password = ""
    @State var confirmPassword = ""
    @State private var error = ""

    @State private var navigatingNextView = false

    private let spacing: CGFloat = 16
    private let symbolsCount = 6

    var body: some View {
        VStack(spacing: spacing) {

            ErrorText(error: error)

            InputField(placeholder: "Password", text: $password, isSecureField: true)
            InputField(placeholder: "Confirm Password", text: $confirmPassword, isSecureField: true)

            NavigationLink(destination: ChooseTagsView(), isActive: $navigatingNextView) {
                EmptyView()
            }
        }
            .navigationBarTitle("Password", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: nextClicked) {
                Text("Next")
            })
    }

    private func nextClicked() {
        error = validate()
        if error.isEmpty {
            navigatingNextView = true
        }
    }

    private func validate() -> String {
        if password.isEmpty {
            return "Password is empty"
        }
        if confirmPassword.isEmpty {
            return "Confirm Password is empty"
        }
        if password.count < symbolsCount {
            return "Password is less than \(symbolsCount) symbols"
        }
        if confirmPassword != password {
            return "Password and confirm password does no match"
        }

        return ""
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}