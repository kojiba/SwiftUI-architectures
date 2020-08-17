//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

protocol PostsViewModelDelegate: class {
    func navigateLogout()
}

protocol PostsViewModelProtocol: ObservableObject {

    var delegate: PostsViewModelDelegate? { get }
    var network: NetworkProtocol { get }

    init(delegate: PostsViewModelDelegate)

    var tags: [String] { get set }
    var posts: [PostModel] { get }

    var isLoading: Bool { get }

    func onAppear()
    func logoutClicked()
}

class PostsViewModel: PostsViewModelProtocol {
    @Published var tags: [String] = []
    @Published private(set) var posts: [PostModel] = []

    @Published var isLoading: Bool = false

    @Published var network: NetworkProtocol = Network.shared

    private(set) weak var delegate: PostsViewModelDelegate?

    required init(delegate: PostsViewModelDelegate) {
        self.delegate = delegate
    }

    /// Actions

    func onAppear() {
        isLoading = true

        network.getPosts(tags: tags) { models in

            self.posts = models
            self.isLoading = false
        }
    }

    func logoutClicked() {
        delegate?.navigateLogout()
    }
}