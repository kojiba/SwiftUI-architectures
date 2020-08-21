//
// Created by kojiba on 20.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class EditBasicInfoViewModel: ObservableObject {

    @Published private(set) var state = State.idle

    private weak var coordinator: ApplicationFlowCoordinator?
    private var store = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()

    enum State {
        case idle
        case error(String)
        case navigating(AnyView)
    }

    enum Event {
        case onAppear
        case nextClicked(String, String)
    }

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
                    
                case .nextClicked(let name, let email):

                    let error = strongSelf.validate(name: name, email: email)
                    
                    guard error.isEmpty else {
                        strongSelf.state = .error(error)
                        return
                    }

                    strongSelf.navigateOrFail(route: .createPassword)
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
    
    private func validate(name: String, email: String) -> String {
        if name.isEmpty {
            return "Name is empty"
        }
        if email.isEmpty {
            return "Email is empty"
        }
        if !isValidEmail(email) {
            return "Email format is wrong, should be x@x.x"
        }
        return ""
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
