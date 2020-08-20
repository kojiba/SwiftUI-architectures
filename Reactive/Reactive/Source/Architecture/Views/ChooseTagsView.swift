//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct ChooseTagsView: View {
    @ObservedObject private var viewModel: ChooseTagsViewModel

    @ObservedObject private var updater = Updater()
    
    private var spacing: CGFloat = 16

    init(viewModel: ChooseTagsViewModel = ChooseTagsViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: .zero) {
            stateView()
        }
            .onAppear(perform: { self.viewModel.send(event: .onAppear) })
            .navigationBarTitle("Choose Tags", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.viewModel.send(event: .nextClicked) }) {
                Text("Next")
            })
    }
    
    func stateView() -> some View {
        switch viewModel.state {
        
        case .loaded(let models):
            return listView(models: models).padding(.top, spacing).toAnyView()
            
        case .loading:
            return loadingView.toAnyView()

        case .error(let error, let models):
            return view(error: error, models: models).toAnyView()

        case .navigating(let destination):
            return activeRoute(to: destination).toAnyView()
        }
    }

    func view(error: String = "", models: [ChooseTagModel]) -> some View {
        VStack(spacing: .zero) {
            
            ErrorText(error: error)
                .padding(.vertical, spacing)

            listView(models: models)
        }
    }

    private func listView(models: [ChooseTagModel]) -> some View {
        ScrollView {
            VStack(spacing: spacing) {

                ForEach(models) { model in
                    VStack {
                        TagView(model: model.tag,
                            isSelected: model.isSelected,
                            clicked: { self.viewModel.send(event: .tagClicked($0))})
                        Divider()
                    }
                        .padding(.horizontal, self.spacing)
                }
            }
        }
    }
}

struct ChooseTagsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTagsView(viewModel: ChooseTagsViewModel(network: ReactiveNetworkMock()))
    }
}