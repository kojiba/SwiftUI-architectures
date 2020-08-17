//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct PostView: View {
    var model: PostModel
    var spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: .zero) {
                Text(model.content)
                Spacer(minLength: .zero)
            }
            
            HStack(spacing: .zero) {
                Text(allTagsText)
                    .foregroundColor(.blue)
                Spacer(minLength: .zero)
            }
        }
    }

    var allTagsText: String {
        model.tags.map { "#\($0)" }.joined(separator: " ")
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(model: .sample)
    }
}