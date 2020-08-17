//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

class ApplicationFlowCoordinator: ObservableObject {

    private lazy var loginViewModel = {
        LoginViewModel(delegate: self)
    }()

    private lazy var editBasicInfoViewModel = {
        EditBasicInfoViewModel(delegate: self)
    }()

    private lazy var createPasswordViewModel = {
        CreatePasswordViewModel(delegate: self)
    }()

    private lazy var chooseTagsViewModel = {
        ChooseTagsViewModel(delegate: self)
    }()

    private lazy var postsViewModel = {
        PostsViewModel(delegate: self)
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

    // Duplicate routes to handle two route states
    private lazy var loginPostsDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(postsView()), isActive: false)
    }()

    private lazy var chooseTagsPostsDirection: DirectionViewModel = {
        DirectionViewModel(view: AnyView(postsView()), isActive: false)
    }()

    func start() -> some View {
        let view = LoginView(model: loginViewModel)
        return nodeView(view, directions: [loginPostsDirection, editBasicInfoViewDirection], isRoot: true)
    }

    private func editBasicInfoView() -> some View {
        let view = EditBasicInfoView(model: editBasicInfoViewModel)
        return nodeView(view, directions: [createPasswordDirection])
    }

    private func createPasswordView() -> some View {
        let view = CreatePasswordView(model: createPasswordViewModel)
        return nodeView(view, directions: [chooseTagsDirection])
    }

    private func chooseTagsView() -> some View {
        let view = ChooseTagsView(model: chooseTagsViewModel)
        return nodeView(view, directions: [chooseTagsPostsDirection])
    }

    private func postsView() -> some View {
        let view = PostsView(model: postsViewModel)
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
        postsViewModel.tags = ["tags", "from", "login"]
        loginPostsDirection.isActive = true
    }

    func navigateSignUp() {
        editBasicInfoViewDirection.isActive = true
    }
}

extension ApplicationFlowCoordinator: CreatePasswordViewModelDelegate {
    func navigateChooseTags() {
        chooseTagsDirection.isActive = true
    }
}

extension ApplicationFlowCoordinator: ChooseTagsViewModelDelegate {
    func navigatePosts() {
        postsViewModel.tags = chooseTagsViewModel.models.filter{ $0.isSelected }.map{ $0.tag.tag }
        chooseTagsPostsDirection.isActive = true
    }
}

extension ApplicationFlowCoordinator: PostsViewModelDelegate {
    func navigateLogout() {
        if loginPostsDirection.isActive {
            loginPostsDirection.isActive = false
            
        } else {

            // todo back to login from choose tags
            editBasicInfoViewDirection.isActive = false
            createPasswordDirection.isActive = false
            chooseTagsDirection.isActive = false
            chooseTagsPostsDirection.isActive = false
        }
    }
}