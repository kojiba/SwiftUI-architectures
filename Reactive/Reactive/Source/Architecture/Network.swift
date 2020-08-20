//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation
import Combine

class Network {
    private let loadingDelay: UInt32 = 2
    static let shared = Network()

    func getTags(completion: @escaping (_: [TagModel]) -> Void) {
        let models = Mocks.tags.map {
            TagModel(tag: $0)
        }
        
        simulateNetwork(result: models, completion: completion)
    }

    func getPosts(tags: [String], completion: @escaping (_: [PostModel]) -> Void) {
        let models = Mocks.posts.map { PostModel(content: $0, tags: tags) }
        
        simulateNetwork(result: models, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (_: Bool) -> Void) {
        simulateNetwork(result: true, completion: completion)
    }

    private func simulateNetwork<Result>(result: Result, completion: @escaping (_ :Result) -> ()) {
        DispatchQueue.global().async {
            self.delay()
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func delay() {
        sleep(self.loadingDelay)
    }
}


