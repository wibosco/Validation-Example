//
//  SecureValidationField.swift
//  Validation-Example
//
//  Created by William Boles on 05/11/2025.
//

import SwiftUI

struct SecureValidationField: View {
    private let title: String
    private let validationState: ValidatedState
    
    @Binding private var text: String
    
    // MARK: - Init
    
    init(_ title: String,
         text: Binding<String>,
         validationState: ValidatedState) {
        self.title = title
        self._text = text
        self.validationState = validationState
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            SecureField(title,
                      text: $text)
                .styleAsInputField()
                .validated(validationState)
        }
    }
}

#Preview {
    SecureValidationField("Email address",
                          text: .constant("test@test.com"),
                          validationState: .unchanged)
}
