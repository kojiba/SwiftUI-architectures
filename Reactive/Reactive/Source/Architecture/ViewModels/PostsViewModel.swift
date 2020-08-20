//
// Created by kojiba on 20.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Combine
import SwiftUI

final class PostsViewModel: ObservableObject {

    @Published private(set) var state = State.loading

    private let tags: [String]
    private let network: ReactiveNetwork
    private var store = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()

    enum State {
        case loading
        case loaded([PostModel])
    }

    enum Event {
        case onAppear
        case logoutClicked
    }

    init(tags: [String], network: ReactiveNetwork = ReactiveNetworkFacade.shared) {
        self.tags = tags
        self.network = network
        
        let queue = DispatchQueue.main

        input
            .receive(on: queue)
            .sink { [weak self] event in
                guard let strongSelf = self else { return }

                switch event {
                case .onAppear:
                    strongSelf.loadPosts(tags: strongSelf.tags)
                case .logoutClicked:
                    // todo
                    print("todo")
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

    private func loadPosts(tags: [String]) {
        self.state = .loading

        self.network
            .getPosts(tags: tags)
            .sink { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.state = .loaded(result)
            }
            .store(in: &self.store)
    }
}
