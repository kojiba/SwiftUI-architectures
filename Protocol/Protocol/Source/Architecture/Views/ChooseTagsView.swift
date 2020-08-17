//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct ChooseTagsView<ViewModel: ChooseTagsViewModelProtocol>: View {
    @ObservedObject var model: ViewModel

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: .zero) {
            ErrorText(error: model.error)
                .padding(.vertical, spacing)
            
            if model.isLoading {
                loadingView
            } else {
                listView
            }
        }
            .onAppear(perform: model.onAppear)
            .navigationBarTitle("Choose Tags", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: model.nextClicked) {
                Text("Next")
            })
    }

    private var listView: some View {
        ScrollView {
            VStack(spacing: spacing) {

                ForEach(model.models) { model in
                    VStack {
                        TagView(model: model.tag, isSelected: model.isSelected, clicked: self.model.tagClicked)
                        Divider()
                    }
                        .padding(.horizontal, self.spacing)
                }
            }
        }
    }
}

struct ChooseTagsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTagsView(model: ChooseTagsViewModelMock())
    }
}