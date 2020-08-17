//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct EditBasicInfoView: View {
    @State var name = ""
    @State var email = ""
    @State private var error = ""

    @State private var navigatingNextView = false

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {

            ErrorText(error: error)

            InputField(placeholder: "Name", text: $name)
            InputField(placeholder: "Email", text: $email)

            NavigationLink(destination: CreatePasswordView(), isActive: $navigatingNextView) {
                EmptyView()
            }
        }
            .navigationBarTitle("Basic Info", displayMode: .inline)
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
        if name.isEmpty {
            return "Name is empty"
        }
        if email.isEmpty {
            return "Email is empty"
        }
        if !isValidEmail(email) {
            return "Email format is wrong, should be x@x.x"
        }
        return ""
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct EditBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditBasicInfoView()
    }
}
