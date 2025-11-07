//
//  FormField.swift
//  Validation-Example
//
//  Created by William Boles on 05/11/2025.
//

import SwiftUI

struct FormField: View {
    private let placeholder: String
    private let title: String?
    private let description: String?
    
    @Environment(\.isSecure) private var isSecure
    @Environment(\.validationState) private var validationState
    
    @Binding private var value: String
    
    // MARK: - Init
    
    init(title: String,
         placeholder: String,
         value: Binding<String>,
         description: String? = nil) {
        self.placeholder = placeholder
        self._value = value
        self.title = title
        self.description = description
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var titleView: some View {
        if let title {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        if let description {
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var validatedView: some View {
        if case let .invalid(errorMessage) = validationState {
            HStack(alignment: .top, spacing: 4) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.caption)
                Text(errorMessage)
                    .font(.caption)
            }
            .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    private var inputView: some View {
        Group {
            if isSecure {
                SecureField(placeholder,
                            text: $value)
            } else {
                TextField(placeholder,
                          text: $value)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .border(validationState.isInvalid ? Color.red : Color.clear, width: 2)
    }
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            titleView
                .padding(.bottom, 6)
            descriptionView
                .padding(.bottom, 6)
            inputView
                .padding(.bottom, 12)

            validatedView
        }
    }
}

// MARK: - SecureField

private struct FormFieldSecure: EnvironmentKey {
  static var defaultValue: Bool = false
}

extension EnvironmentValues {
  var isSecure: Bool {
    get { self[FormFieldSecure.self] }
    set { self[FormFieldSecure.self] = newValue }
  }
}

extension View {
  func isSecure(_ value: Bool = true) -> some View {
    environment(\.isSecure, value)
  }
}

// MARK: - ValidationField

private struct FormFieldValidationState: EnvironmentKey {
    static var defaultValue: ValidatedState = .unchanged
}

extension EnvironmentValues {
  var validationState: ValidatedState {
    get { self[FormFieldValidationState.self] }
    set { self[FormFieldValidationState.self] = newValue }
  }
}

extension View {
    func validationState(_ value: ValidatedState) -> some View {
        environment(\.validationState, value)
    }
}

// MARK: - Preview

#Preview {
    FormField(title: "Email address", placeholder: "Enter your email address", value: .constant("test@test.com"), description: "Must be work email address")
}

