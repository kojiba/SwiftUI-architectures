//
// Created by kojiba on 16.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct ErrorText: View {
    var error: String

    var body: some View {
        Text(error)
            .foregroundColor(Color.red.opacity(0.7))
    }
}

struct ErrorText_Previews: PreviewProvider {
    static var previews: some View {
        ErrorText(error: "Error")
    }
}