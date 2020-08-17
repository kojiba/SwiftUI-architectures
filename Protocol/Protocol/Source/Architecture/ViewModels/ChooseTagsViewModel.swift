//
// Created by kojiba on 17.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import Foundation

class ChooseTagModel: Identifiable, ObservableObject {
    let tag: TagModel
    @Published var isSelected: Bool

    var id: String {
        tag.id
    }

    init(tag: TagModel, isSelected: Bool = false) {
        self.tag = tag
        self.isSelected = isSelected
    }
}

protocol ChooseTagsViewModelDelegate: class {
    func navigatePosts()
}

protocol ChooseTagsViewModelProtocol: ObservableObject {

    var delegate: ChooseTagsViewModelDelegate? { get }
    var network: NetworkProtocol { get }

    init(delegate: ChooseTagsViewModelDelegate)

    var models: [ChooseTagModel] { get }
    var error: String { get }
    var isLoading: Bool { get }

    func onAppear()
    func nextClicked()
    func tagClicked(_:TagModel)
}

class ChooseTagsViewModel: ChooseTagsViewModelProtocol {
    private(set) weak var delegate: ChooseTagsViewModelDelegate?
    private(set) var network: NetworkProtocol = Network.shared

    required init(delegate: ChooseTagsViewModelDelegate) {
        self.delegate = delegate
    }

    @Published private(set) var models: [ChooseTagModel] = []
    @Published private(set) var error: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private var updateCounter = 0

    private let tagsCountToSelect = 3

    /// Actions

    func nextClicked() {
        error = validate()
        if error.isEmpty {
            delegate?.navigatePosts()
        }
    }

    func onAppear() {
        isLoading = true
        network.getTags { models in

            self.models = models.map { ChooseTagModel(tag: $0) }
            self.isLoading = false
        }
    }

    func tagClicked(_ model: TagModel) {
        models.filter { $0.tag == model }.first?.isSelected.toggle()
        updateCounter += 1 // hack to update view
    }

    /// Logic

    private func validate() -> String {
        if (models.filter { $0.isSelected }).count < tagsCountToSelect {
            return "You need select at least \(tagsCountToSelect) tags"
        }
        return ""
    }
}

