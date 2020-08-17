//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: class {
    func navigateHome()
    func navigateSignUp()
}

protocol LoginViewModelProtocol: ObservableObject {

    var delegate: LoginViewModelDelegate? { get }
    var network: NetworkProtocol { get }

    init(delegate: LoginViewModelDelegate)

    var email: String { get set }
    var password: String { get set }

    var isLoading: Bool { get set }
    var error: String { get set }

    func loginButtonClicked()
    func signUpClicked()
}

class LoginViewModel: LoginViewModelProtocol {

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var error: String = ""

    @Published var network: NetworkProtocol = Network.shared

    private(set) weak var delegate: LoginViewModelDelegate?

    required init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }

    func loginButtonClicked() {
        let error = self.validate()
        self.error = error

        if !error.isEmpty {
            return
        }

        isLoading = true

        network.login(email: email, password: password) { [weak self] result in
            guard let strongSelf = self else { return }

            strongSelf.isLoading = false

            strongSelf.clearCreds()
            strongSelf.delegate?.navigateHome()
        }
    }

    func signUpClicked() {
        delegate?.navigateSignUp()
    }

    private func validate() -> String {
        if email.isEmpty {
            return "Email is empty"
        }
        if password.isEmpty {
            return "Password is empty"
        }

        return ""
    }

    private func clearCreds() {
        self.email = ""
        self.password = ""
    }
}