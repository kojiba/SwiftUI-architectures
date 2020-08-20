//
// Created by kojiba on 19.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle

    private let network = ReactiveNetworkFacade.shared

    private var store = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    enum State {
        case idle
        case loading
        case error(String)
        case navigating(AnyView)
    }

    enum Event {
        case loginClicked(String, String)
        case signUpClicked
    }

    init() {
        let queue = DispatchQueue.main
        
        input
            .receive(on: queue)
            .sink { event in
                switch event {

                case .signUpClicked: do {

                    switch self.state {
                    case .idle, .error:
                        self.state = .navigating(self.editBasicInfoView())
                    default: do {}
                    }
                }
                    
                case .loginClicked(let email, let password):

                    switch self.state {
                    case .idle, .error:
                        let error = self.validate(email: email, password: password)
                        if !error.isEmpty {
                            self.state = .error(error)
                            return
                        }

                        self.state = .loading

                        self.network
                            .login(email: email, password: password)
                            .sink(receiveCompletion: { completion in
                                
                            }, receiveValue: { b in

                                if b {
                                    self.state = .idle
                                    self.state = .navigating(self.postsView())
                                } else {
                                    self.state = .error("Failed to login")
                                }
                            })
                            .store(in: &self.store)
                    }
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

    private func postsView() -> AnyView {
        PostsView(tags: ["Login", "Tag", "1"]).toAnyView()
    }

    private func editBasicInfoView() -> AnyView {
        EditBasicInfoView().toAnyView()
    }

    /// Logic

    private func validate(email: String, password: String) -> String {
        if email.isEmpty {
            return "Email is empty"
        }
        if password.isEmpty {
            return "Password is empty"
        }

        return ""
    }
}
