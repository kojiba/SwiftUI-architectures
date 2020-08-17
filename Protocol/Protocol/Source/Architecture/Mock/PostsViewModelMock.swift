//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

import Foundation

class PostsViewModelDelegateMock: PostsViewModelDelegate {
    func navigateLogout() {
        print("navigateLogout")
    }
}

extension PostModel {
    static let sample = PostModel(content: "Lorem ipsum dolor sit amet", tags: ["Test", "Demo", "Post"])
}

class PostsViewModelMock: PostsViewModelProtocol {
    private(set) var delegate: PostsViewModelDelegate?

    required init(delegate: PostsViewModelDelegate = PostsViewModelDelegateMock()) {
        self.delegate = delegate
    }

    private(set) var network: NetworkProtocol = NetworkMock.shared
    var tags: [String] = ["1", "2", "3"]
    private(set) var posts: [PostModel] = [.sample, .sample, .sample]
    private(set) var isLoading: Bool = false

    func onAppear() {
        print("onAppear")
    }

    func logoutClicked() {
        print("logoutClicked")
    }
}