//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct PostsView: View {

    @ObservedObject private var viewModel: PostsViewModel

    private var spacing: CGFloat = 16

    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: .zero) {
            stateView
        }
            .onAppear(perform: { self.viewModel.send(event: .onAppear) })
            .navigationBarTitle("Posts", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button(action: { self.viewModel.send(event: .logoutClicked) }) {
                Text("Logout")
            })
    }

    private var stateView: some View {
        switch viewModel.state {
        case .loaded(let models):
            return listView(models: models).toAnyView()

        case .loading:
            return loadingView.toAnyView()
        }
    }

    private func listView(models: [PostModel]) -> some View {
        ScrollView {
            VStack(spacing: spacing) {

                ForEach(models) { model in
                    VStack {
                        PostView(model: model)
                        Divider()
                    }
                        .padding(.horizontal, self.spacing)
                }
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(viewModel: PostsViewModel(tags: ["1", "demo", "some"], network: ReactiveNetworkMock(), coordinator: .previewCoordinator))
    }
}