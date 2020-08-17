//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class ChooseTagsViewModelDelegateMock: ChooseTagsViewModelDelegate {
    func navigatePosts() {
        print("navigatePosts")
    }
}

extension ChooseTagModel {
    static var randomSample: ChooseTagModel {
        let randomTags = ["Animals", "Vegetables", "Pets", "Cats", "Dogs", "Cars", "History", "War"]
        let tagIndex = Int.random(in: 0 ..< randomTags.count - 1)
        return ChooseTagModel(tag: TagModel(tag: randomTags[tagIndex]), isSelected: Bool.random())
    }
}

class ChooseTagsViewModelMock: ChooseTagsViewModelProtocol {
    private(set) var delegate: ChooseTagsViewModelDelegate?
    private(set) var network: NetworkProtocol = NetworkMock.shared

    required init(delegate: ChooseTagsViewModelDelegate = ChooseTagsViewModelDelegateMock()) {
        self.delegate = delegate
    }

    private(set) var models: [ChooseTagModel] = [.randomSample, .randomSample, .randomSample]
    private(set) var isLoading: Bool = false
    var error: String = ""

    func nextClicked() {
        print("nextClicked")
    }

    func onAppear() {
        print("onAppear")
    }

    func tagClicked(_ model: TagModel) {
        print("tagClicked")
    }

}
