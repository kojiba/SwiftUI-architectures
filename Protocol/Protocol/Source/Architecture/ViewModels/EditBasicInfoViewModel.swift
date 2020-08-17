//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

protocol EditBasicInfoViewModelDelegate: class {
    func navigateCreatePassword()
}

protocol EditBasicInfoViewModelProtocol: ObservableObject {

    var delegate: EditBasicInfoViewModelDelegate? { get }

    init(delegate: EditBasicInfoViewModelDelegate)

    var name: String { get set }
    var email: String { get set }
    var error: String { get set }

    func nextButtonClicked()
}

class EditBasicInfoViewModel: EditBasicInfoViewModelProtocol {

    private(set) var delegate: EditBasicInfoViewModelDelegate?

    required init(delegate: EditBasicInfoViewModelDelegate) {
        self.delegate = delegate
    }

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var error: String = ""

    func nextButtonClicked() {
        let error = self.validate()
        self.error = error

        if !error.isEmpty {
            return
        }

        delegate?.navigateCreatePassword()
    }

    private func validate() -> String {
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
