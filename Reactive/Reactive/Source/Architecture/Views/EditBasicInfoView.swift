//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct EditBasicInfoView: View {
    @ObservedObject var viewModel = EditBasicInfoViewModel()
    
    @State var name = ""
    @State var email = ""

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: 0) {
            stateView()
        }
            .onAppear(perform: { self.viewModel.send(event: .onAppear)})
            .navigationBarTitle("Basic Info", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.viewModel.send(event: .nextClicked(self.name, self.email)) }) {
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

            InputField(placeholder: "Name", text: $name)
            InputField(placeholder: "Email", text: $email)
        }
    }
}

struct EditBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditBasicInfoView()
    }
}
