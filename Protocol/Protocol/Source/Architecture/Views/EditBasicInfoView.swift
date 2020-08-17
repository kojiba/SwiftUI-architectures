//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct EditBasicInfoView<ViewModel: EditBasicInfoViewModelProtocol>: View {
    @ObservedObject var model: ViewModel

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {
            ErrorText(error: model.error)

            InputField(placeholder: "Name", text: $model.name)
            InputField(placeholder: "Email", text: $model.email)
        }
            .navigationBarTitle("Basic Info", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: model.nextButtonClicked) {
                Text("Next")
            })
    }
}

struct EditBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditBasicInfoView(model: EditBasicInfoViewModelMock())
    }
}
