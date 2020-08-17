//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class CreatePasswordViewModelDelegateMock: CreatePasswordViewModelDelegate {
    func navigateChooseTags() {
        print("navigateChooseTags")
    }
}

class CreatePasswordViewModelMock: CreatePasswordViewModelProtocol {
    private(set) var delegate: CreatePasswordViewModelDelegate?

    required init(delegate: CreatePasswordViewModelDelegate = CreatePasswordViewModelDelegateMock()) {
        self.delegate = delegate
    }

    var password: String = ""
    var confirmPassword: String = ""
    var error: String = ""

    func nextClicked() {
        print("nextClicked")
    }
}
