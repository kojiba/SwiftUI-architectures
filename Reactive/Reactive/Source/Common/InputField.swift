//
// Created by kojiba on 15.08.2020.
// Copyright (c) 2020 kojiba. All rights reserved.
//

import SwiftUI

struct InputField: View {
    let spacing: CGFloat = 16

    var placeholder: String
    @Binding var text: String

    var isSecureField = false
    
    var body: some View {
        VStack {
            if isSecureField {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            Divider()
        }
            .padding(.horizontal, spacing)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(placeholder: "Input field", text: .constant(""))
    }
}