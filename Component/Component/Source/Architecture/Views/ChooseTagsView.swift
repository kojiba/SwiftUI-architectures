//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

class ChooseTagModel: Identifiable, ObservableObject {
    let tag: TagModel
    @Published var isSelected: Bool

    var id: String {
        tag.id
    }

    init(tag: TagModel, isSelected: Bool = false) {
        self.tag = tag
        self.isSelected = isSelected
    }
}

extension ChooseTagModel {
    static var randomSample: ChooseTagModel {
        let randomTags = ["Animals", "Vegetables", "Pets", "Cats", "Dogs", "Cars", "History", "War"]
        let tagIndex = Int.random(in: 0 ..< randomTags.count - 1)
        return ChooseTagModel(tag: TagModel(tag: randomTags[tagIndex]), isSelected: Bool.random())
    }
}

struct ChooseTagsView: View {
    @State private var models: [ChooseTagModel] = []
    private var isPreview = false

    private let network = Network.shared
    
    @State private var error = ""
    @State private var isLoading = false

    @State private var navigatingNextView = false

    @ObservedObject private var updater = Updater()

    private let tagsCountToSelect = 3
    private var spacing: CGFloat = 16

    init(models: [ChooseTagModel] = [], isPreview: Bool = false) {
        _models = State(initialValue: models)
        self.isPreview = isPreview
    }

    var body: some View {
        VStack(spacing: .zero) {
            ErrorText(error: error)
                .padding(.vertical, spacing)
            
            if isLoading {
                loadingView
            } else {
                listView
            }
            
            NavigationLink(destination: PostsView(tags: models.filter { $0.isSelected }.map { $0.tag.tag }), isActive: $navigatingNextView) {
                EmptyView()
            }
        }
            .onAppear(perform: onAppear)
            .navigationBarTitle("Choose Tags", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: nextClicked) {
                Text("Next")
            })
    }

    private var listView: some View {
        ScrollView {
            VStack(spacing: spacing) {

                ForEach(models) { model in
                    VStack {
                        TagView(model: model.tag, isSelected: model.isSelected, clicked: self.tagClicked)
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
        network.getTags { models in
            
            self.models = models.map { ChooseTagModel(tag: $0) }
            self.isLoading = false
        }
    }
    
    private func tagClicked(_ model: TagModel) {
        models.filter { $0.tag == model }.first?.isSelected.toggle()
        updater.update() // Hack to update view
    }

    private func nextClicked() {
        error = validate()
        if error.isEmpty {
            navigatingNextView = true
        }
    }

    /// Logic

    private func validate() -> String {
        if (models.filter { $0.isSelected }).count < tagsCountToSelect {
            return "You need select at least \(tagsCountToSelect) tags"
        }
        return ""
    }
}

struct ChooseTagsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTagsView(models: [.randomSample, .randomSample, .randomSample, .randomSample, .randomSample], isPreview: true)
    }
}