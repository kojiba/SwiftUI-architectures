//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

struct TagModel: Identifiable {
    var tag: String

    var id: String {
        tag
    }
}

extension TagModel {
    static let sample: TagModel = TagModel(tag: "Demo tag")
}

extension TagModel: Equatable {
    public static func ==(lhs: TagModel, rhs: TagModel) -> Bool {
        lhs.id == rhs.id
    }
}