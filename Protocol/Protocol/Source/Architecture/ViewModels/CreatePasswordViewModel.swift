//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

protocol CreatePasswordViewModelDelegate: class {
    func navigateChooseTags()
}

protocol CreatePasswordViewModelProtocol: ObservableObject {

    var delegate: CreatePasswordViewModelDelegate? { get }

    init(delegate: CreatePasswordViewModelDelegate)

    var password: String { get set }
    var confirmPassword: String { get set }

    var error: String { get set }

    func nextClicked()
}

class CreatePasswordViewModel: CreatePasswordViewModelProtocol {
    private(set) weak var delegate: CreatePasswordViewModelDelegate?

    required init(delegate: CreatePasswordViewModelDelegate) {
        self.delegate = delegate
    }

    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var error: String = ""

    private let symbolsCount = 6

    func nextClicked() {
        error = validate()
        if error.isEmpty {
            delegate?.navigateChooseTags()
        }
    }

    private func validate() -> String {
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
