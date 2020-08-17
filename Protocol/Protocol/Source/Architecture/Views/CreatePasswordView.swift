//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct CreatePasswordView<ViewModel: CreatePasswordViewModelProtocol>: View {
    @ObservedObject var model: ViewModel

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {

            ErrorText(error: model.error)

            InputField(placeholder: "Password", text: $model.password, isSecureField: true)
            InputField(placeholder: "Confirm Password", text: $model.confirmPassword, isSecureField: true)
        }
            .navigationBarTitle("Password", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: model.nextClicked) {
                Text("Next")
            })
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(model: CreatePasswordViewModelMock())
    }
}