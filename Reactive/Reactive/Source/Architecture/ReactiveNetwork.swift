//
// Created by kojiba on 20.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Combine

protocol ReactiveNetwork {
    func login(email: String, password: String) -> AnyPublisher<Bool, Never>
    func getTags() -> AnyPublisher<[TagModel], Never>
    func getPosts(tags: [String]) -> AnyPublisher<[PostModel], Never>
}

class ReactiveNetworkMock: ReactiveNetwork {
    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        Just(true).eraseToAnyPublisher()
    }

    func getTags() -> AnyPublisher<[TagModel], Never> {
        Just([.sample, .sample, .sample]).eraseToAnyPublisher()
    }

    func getPosts(tags: [String]) -> AnyPublisher<[PostModel], Never> {
        Just([.sample, .sample, .sample]).eraseToAnyPublisher()
    }
}

class ReactiveNetworkFacade: ReactiveNetwork {
    static let shared = ReactiveNetworkFacade()
    private let network = Network.shared

    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            self.network.login(email: email, password: password) { result in
                promise(.success(result))
            }
        }
            .eraseToAnyPublisher()
    }

    func getTags() -> AnyPublisher<[TagModel], Never> {
        Future<[TagModel], Never> { promise in
            self.network.getTags { result in
                promise(.success(result))
            }
        }
            .eraseToAnyPublisher()
    }

    func getPosts(tags: [String]) -> AnyPublisher<[PostModel], Never> {
        Future<[PostModel], Never> { promise in
            self.network.getPosts(tags: tags) { result in
                promise(.success(result))
            }
        }
            .eraseToAnyPublisher()
    }
}