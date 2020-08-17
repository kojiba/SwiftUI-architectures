//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

struct PostModel: Identifiable {
    var content: String
    var tags: [String]

    var id: String = UUID().uuidString
}