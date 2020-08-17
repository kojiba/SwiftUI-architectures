//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

class DirectionViewModel: ObservableObject, Identifiable {
    @Published var isActive: Bool
    let view: AnyView
    public var id = UUID().uuidString

    init(view: AnyView, isActive: Bool) {
        self.view = view
        self.isActive = isActive
    }
}

struct DirectionView: View {
    @ObservedObject var model: DirectionViewModel

    var body: some View {
        NavigationLink(destination: model.view, isActive: $model.isActive) {
            EmptyView()
        }
    }
}

struct NodeView: View {

    var view: AnyView
    var directions: [DirectionViewModel]
    var isRoot = false

    var body: some View {
        if isRoot {
            return AnyView(NavigationView {
                mainView
            })
        } else {
            return AnyView(mainView)
        }
    }

    private var mainView: some View {
        VStack(spacing: .zero) {
            view
                .navigationViewStyle(StackNavigationViewStyle())

            ForEach(directions) { model in
                DirectionView(model: model)
            }
        }
    }
}