//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct CreatePasswordView: View {
    @ObservedObject var viewModel: CreatePasswordViewModel
    
    @State var password = ""
    @State var confirmPassword = ""
    
    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: .zero) {
            stateView()
        }
            .onAppear(perform: { self.viewModel.send(event: .onAppear)})
            .navigationBarTitle("Password", displayMode: .inline)
            .navigationBarItems(trailing:
            Button(action: { self.viewModel.send(event: .nextClicked(self.password, self.confirmPassword)) }) {
                Text("Next")
            })
    }

    func stateView() -> some View {
        switch viewModel.state {
        case .idle:
            return view().toAnyView()

        case .error(let error):
            return view(error: error).toAnyView()

        case .navigating(let destination):
            return activeRoute(to: destination).toAnyView()
        }
    }

    func view(error: String = "") -> some View {
        VStack(spacing: spacing) {

            ErrorText(error: error)

            InputField(placeholder: "Password", text: $password, isSecureField: true)
            InputField(placeholder: "Confirm Password", text: $confirmPassword, isSecureField: true)
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(viewModel: CreatePasswordViewModel(coordinator: .previewCoordinator))
    }
}