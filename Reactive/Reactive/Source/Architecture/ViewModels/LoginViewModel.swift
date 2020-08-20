//
// Created by kojiba on 19.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    
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
        case onAppear
        case loginClicked(String, String)
        case signUpClicked
    }

    init() {
        let queue = DispatchQueue.main
        
        input
            .receive(on: queue)
            .filter { [weak self] _ in
                guard let state = self?.state else { return false }
                switch state {
                case .loading:
                    return false
                case .idle, .error, .navigating:
                    // Only progress if we're idle or in error state
                    return true
                }
            }
            .sink { [weak self] event in
                guard let strongSelf = self else { return }
                
                switch event {
                case .onAppear:
                    strongSelf.state = .idle
                    
                case .signUpClicked:
                    strongSelf.state = .navigating(strongSelf.editBasicInfoView())
                    
                case .loginClicked(let email, let password):
                    guard strongSelf.canLoad else { return }

                    let error = strongSelf.validate(email: email, password: password)
                    
                    guard error.isEmpty else {
                        strongSelf.state = .error(error)
                        return
                    }
                    
                    strongSelf.performLogin(email: email, password: password)
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

    private func validate(email: String, password: String) -> String {
        if email.isEmpty {
            return "Email is empty"
        }
        if password.isEmpty {
            return "Password is empty"
        }

        return ""
    }

    private var canLoad: Bool {
        switch state {
        case .idle, .error:
            return true
        default:
            return false
        }
    }
    
    private func performLogin(email: String, password: String) {
        self.state = .loading

        self.network
            .login(email: email, password: password)
            .sink { [weak self] success in
                guard let self = self else {
                    return
                }
                if success {
                    self.state = .idle
                    self.state = .navigating(self.postsView())
                } else {
                    self.state = .error("Failed to login")
                }
            }
            .store(in: &self.store)
    }

    /// Routes

    private func postsView() -> AnyView {
        PostsView(viewModel: PostsViewModel(tags: ["Login", "Tag", "1"])).toAnyView()
    }

    private func editBasicInfoView() -> AnyView {
        EditBasicInfoView().toAnyView()
    }
}
