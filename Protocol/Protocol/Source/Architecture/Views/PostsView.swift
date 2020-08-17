//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct PostsView<ViewModel: PostsViewModelProtocol>: View {
    @ObservedObject var model: ViewModel

    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: .zero) {
            if model.isLoading {
                loadingView
            } else {
                listView
            }
        }
            .onAppear(perform: model.onAppear)
            .navigationBarTitle("Posts", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button(action: model.logoutClicked) {
                Text("Logout")
            })
    }

    private var listView: some View {
        ScrollView {
            VStack(spacing: spacing) {

                ForEach(model.posts) { post in
                    VStack {
                        PostView(model: post)
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
        PostsView(model: PostsViewModelMock())
    }
}