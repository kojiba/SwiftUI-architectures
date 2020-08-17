//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

/// NOTE: A hack to update Views
class Updater: ObservableObject {
    @Published private var updateCounter = 0

    func update() {
        updateCounter += 1
    }
}
