//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

class ApplicationFlowCoordinator: ObservableObject {

    private lazy var loginViewModel: LoginViewModel = {
        LoginViewModel(delegate: self)
    }()

    private lazy var editBasicInfoViewModel: EditBasicInfoViewModel = {
        EditBasicInfoViewModel(delegate: self)
    }()

    private lazy var editBasicInfoViewDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(editBasicInfoView()), isActive: false)
    }()

    private lazy var createPasswordDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(createPasswordView()), isActive: false)
    }()

    private lazy var chooseTagsDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(chooseTagsView()), isActive: false)
    }()

    private lazy var postsDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(postsView()), isActive: false)
    }()

    func start() -> some View {
        let view = LoginView(model: loginViewModel)
        return nodeView(view, directions: [postsDirection, editBasicInfoViewDirection], isRoot: true)
    }

    private func editBasicInfoView() -> some View {
        let view = EditBasicInfoView(model: editBasicInfoViewModel)
        return nodeView(view, directions: [createPasswordDirection])
    }

    private func createPasswordView() -> some View {
        let view = CreatePasswordView()
        return nodeView(view, directions: [chooseTagsDirection])
    }

    private func chooseTagsView() -> some View {
        let view = ChooseTagsView()
        return nodeView(view, directions: [postsDirection])
    }

    private func postsView() -> some View {
        let view = PostsView(tags: ["1"])
        return nodeView(view, directions: [])
    }

    private func nodeView<V: View>(_ view: V, directions: [DirectionViewModel], isRoot: Bool = false) -> some View {
        NodeView(view: AnyView(view), directions: directions, isRoot: isRoot)
    }
}

extension ApplicationFlowCoordinator: EditBasicInfoViewModelDelegate {
    func navigateCreatePassword() {
        createPasswordDirection.isActive = true
    }
}

extension ApplicationFlowCoordinator: LoginViewModelDelegate {
    func navigateHome() {
        self.postsDirection.isActive = true
    }

    func navigateSignUp() {
        self.editBasicInfoViewDirection.isActive = true
    }
}