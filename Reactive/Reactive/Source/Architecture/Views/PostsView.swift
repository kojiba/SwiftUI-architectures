//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct PostsView: View {
    @State private var tags: [String]
    @State private var models: [PostModel]
    private var isPreview: Bool
    @Binding private var goingLogin: Bool 

    private let network = Network.shared
    
    @State private var isLoading = false

    @ObservedObject private var updater = Updater()

    private let tagsCountToSelect = 3
    private var spacing: CGFloat = 16
    
    init(tags: [String], models: [PostModel] = [], isPreview: Bool = false, goingLogin: Binding<Bool> = .constant(false)) {
        _tags = State(initialValue: tags)
        _models = State(initialValue: models)
        _goingLogin = goingLogin
        self.isPreview = isPreview
    }

    var body: some View {
        VStack(spacing: .zero) {
            if isLoading {
                loadingView
            } else {
                listView
            }
        }
            .onAppear(perform: onAppear)
            .navigationBarTitle("Posts", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button(action: logoutClicked) {
                Text("Logout")
            })
    }

    private var listView: some View {
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

    /// Actions

    private func onAppear() {
        if isPreview { return }

        isLoading = true
        network.getPosts(tags: tags) { models in

            self.models = models
            self.isLoading = false
        }
    }
    
    private func logoutClicked() {
        goingLogin.toggle()
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(tags: ["preview", "test"], 
            models: [.sample, .sample, .sample, .sample, .sample], isPreview: true)
    }
}