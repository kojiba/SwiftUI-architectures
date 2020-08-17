//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class LoginViewModelDelegateMock: LoginViewModelDelegate {
    func navigateHome() {
        print("navigateHome")
    }

    func navigateSignUp() {
        print("navigateSignUp")
    }
}

class LoginViewModelMock: LoginViewModelProtocol {
    private(set) var delegate: LoginViewModelDelegate?
    private(set) var network: NetworkProtocol = NetworkMock.shared

    required init(delegate: LoginViewModelDelegate = LoginViewModelDelegateMock()) {
        self.delegate = delegate
    }

    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var error: String = ""

    func loginButtonClicked() {
        print("loginButtonClicked")
    }

    func signUpClicked() {
        print("signUpClicked")
    }
}
