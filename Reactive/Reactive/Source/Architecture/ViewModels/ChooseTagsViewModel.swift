//
// Created by kojiba on 20.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

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

final class ChooseTagsViewModel: ObservableObject {
    
    private(set) var state = State.loading {
        willSet {
            objectWillChange.send()
        }
    }

    private var tagModels: [ChooseTagModel] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()

    private let network: ReactiveNetwork
    private var store = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()

    private let tagsCountToSelect = 3

    enum State {
        case error(String, [ChooseTagModel])
        case loading
        case loaded([ChooseTagModel])
        case navigating(AnyView)
    }

    enum Event {
        case onAppear
        case tagClicked(TagModel)
        case nextClicked
    }

    init(network: ReactiveNetwork = ReactiveNetworkFacade.shared) {
        self.network = network

        let queue = DispatchQueue.main

        input
            .receive(on: queue)
            .sink { [weak self] event in
                guard let strongSelf = self else { return }

                switch event {
                case .onAppear:
                    if strongSelf.tagModels.isEmpty {
                        strongSelf.getTags()
                    } else {
                        strongSelf.state = .loaded(strongSelf.tagModels)
                    }

                case .tagClicked(let tagModel):
                    guard strongSelf.canSelectTags else { return }

                    strongSelf.tagModels.filter { $0.tag == tagModel }.first?.isSelected.toggle()
                    strongSelf.objectWillChange.send()

                case .nextClicked:
                    
                    let error = strongSelf.validate()

                    guard error.isEmpty else {
                        strongSelf.state = .error(error, strongSelf.tagModels)
                        return
                    }

                    strongSelf.state = .navigating(strongSelf.postsView())
                }
            }
            .store(in: &store)
    }

    deinit {
        store.forEach { $0.cancel() }
    }


    func send(event: Event) {
        input.send(event)
    }

    /// Logic

    private var canSelectTags: Bool {
        switch state {
        case .loading:
            return false
        default:
            return true
        }
    }

    private func validate() -> String {
        if (tagModels.filter { $0.isSelected }).count < tagsCountToSelect {
            return "You need select at least \(tagsCountToSelect) tags"
        }
        return ""
    }
    
    private func getTags() {
        self.state = .loading

        self.network
            .getTags()
            .map { $0.map { ChooseTagModel(tag: $0) } }
            .sink { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.tagModels = result
                
                strongSelf.state = .loaded(result)
            }
            .store(in: &self.store)
    }

    /// Routes

    private func postsView() -> AnyView {
        let selectedTags = self.tagModels
            .filter { $0.isSelected }
            .map { $0.tag.tag }
        
        return PostsView(viewModel: PostsViewModel(tags: selectedTags)).toAnyView()
    }
}
