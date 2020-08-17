//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct TagView: View {
    var model: TagModel
    var isSelected: Bool = false

    var clicked: (_: TagModel) -> () = { _ in }

    var spacing: CGFloat = 16

    var body: some View {
        Button(action: { self.clicked(self.model) }) {
            HStack(spacing: spacing) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(.blue)
                Text(model.tag)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TagView(model: .sample)
            TagView(model: .sample, isSelected: false)
        }
    }
}
