//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class NetworkMock: NetworkProtocol {
    static let shared = NetworkMock()

    func getTags(completion: @escaping ([TagModel]) -> ()) {
        print(getTags)
    }

    func getPosts(tags: [String], completion: @escaping ([PostModel]) -> ()) {
        print(getPosts)
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> ()) {
        print(login)
    }
}
