//
// Created by kojiba on 20.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class CreatePasswordViewModel: ObservableObject {

    @Published private(set) var state = State.idle

    private var store = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    private weak var coordinator: ApplicationFlowCoordinator?

    enum State {
        case idle
        case error(String)
        case navigating(AnyView)
    }

    enum Event {
        case onAppear
        case nextClicked(String, String)
    }

    private let symbolsCount = 6

    init(coordinator: ApplicationFlowCoordinator) {
        self.coordinator = coordinator
        
        let queue = DispatchQueue.main

        input
            .receive(on: queue)
            .sink { [weak self] event in
                guard let strongSelf = self else { return }

                switch event {
                case .onAppear:
                    strongSelf.state = .idle

                case .nextClicked(let password, let confirmPassword):

                    let error = strongSelf.validate(password: password, confirmPassword: confirmPassword)

                    guard error.isEmpty else {
                        strongSelf.state = .error(error)
                        return
                    }

                    guard strongSelf.canNavigate else { return }

                    strongSelf.navigateOrFail(route: .chooseTags)
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

    private func navigateOrFail(route: ApplicationFlowCoordinator.Route) {
        guard let view = coordinator?.view(for: route) else {
            state = .error("Cannot load next view")
            return
        }

        state = .navigating(view)
    }

    private var canNavigate: Bool {
        switch state {
        case .navigating:
            return false
        default:
            return true
        }
    }
    
    private func validate(password: String, confirmPassword: String) -> String {
        if password.isEmpty {
            return "Password is empty"
        }
        if confirmPassword.isEmpty {
            return "Confirm Password is empty"
        }
        if password.count < symbolsCount {
            return "Password is less than \(symbolsCount) symbols"
        }
        if confirmPassword != password {
            return "Password and confirm password does no match"
        }

        return ""
    }
}
