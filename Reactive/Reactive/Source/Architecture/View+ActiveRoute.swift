//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

extension View {
    func activeRoute<V: View>(to view: V) -> some View {
        NavigationLink(destination: view, isActive: .constant(true)) {
            EmptyView()
        }
    }
}