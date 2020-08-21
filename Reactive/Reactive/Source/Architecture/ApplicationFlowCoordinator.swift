//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

class ApplicationFlowCoordinator {

    enum Route {
        case login
        case posts([String])
        case editBasicInfo
        case createPassword
        case chooseTags
    }
    
    private var loginViewModel: LoginViewModel!
    private var editBasicInfoViewModel: EditBasicInfoViewModel!
    private var createPasswordViewModel: CreatePasswordViewModel!
    private var chooseTagsViewModel: ChooseTagsViewModel!
    private var postsViewModel: PostsViewModel!

    private func editBasicInfoView() -> AnyView {
        editBasicInfoViewModel = EditBasicInfoViewModel(coordinator: self)
        return EditBasicInfoView(viewModel: editBasicInfoViewModel).toAnyView()
    }

    private func createPasswordView() -> AnyView {
        createPasswordViewModel = CreatePasswordViewModel(coordinator: self)
        return CreatePasswordView(viewModel: createPasswordViewModel).toAnyView()
    }
    
    private func chooseTagsView() -> AnyView {
        chooseTagsViewModel = ChooseTagsViewModel(coordinator: self)
        return ChooseTagsView(viewModel: chooseTagsViewModel).toAnyView()
    }
    
    private func postsView(tags: [String]) -> AnyView {
        postsViewModel = PostsViewModel(tags: tags, coordinator: self)
        return PostsView(viewModel: postsViewModel).toAnyView()
    }

    private func loginView() -> AnyView {
        loginViewModel = LoginViewModel(coordinator: self)
        return LoginView(viewModel: loginViewModel).toAnyView()
    }

    func view(for route: Route) -> AnyView {
        switch route {

        case .login:
            return loginView()
            
        case .posts(let tags):
            return postsView(tags: tags)

        case .chooseTags:
            return chooseTagsView()

        case .createPassword:
            return createPasswordView()

        case .editBasicInfo:
            return editBasicInfoView()
        }
    }
}

extension ApplicationFlowCoordinator {
    static let previewCoordinator = ApplicationFlowCoordinator()
}