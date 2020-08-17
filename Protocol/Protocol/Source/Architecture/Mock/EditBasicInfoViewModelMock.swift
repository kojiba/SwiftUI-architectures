//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class EditBasicInfoViewModelDelegateMock: EditBasicInfoViewModelDelegate {
    func navigateCreatePassword() {
        print("navigateCreatePassword")
    }
}

class EditBasicInfoViewModelMock: EditBasicInfoViewModelProtocol {
    private(set) var delegate: EditBasicInfoViewModelDelegate?

    required init(delegate: EditBasicInfoViewModelDelegate = EditBasicInfoViewModelDelegateMock()) {
        self.delegate = delegate
    }

    var name: String = ""
    var email: String = ""
    var error: String = ""

    func nextButtonClicked() {
        print("nextButtonClicked")
    }
}
