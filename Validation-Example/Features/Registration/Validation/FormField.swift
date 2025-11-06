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
    
    @State private var validationState: ValidatedState = .unchanged
    
    @Environment(\.isSecure) var isSecure
    @Environment(\.validationHandler) var validationHandler
    
    @Binding private var text: String
    
    // MARK: - Init
    
    init(_ placeholder: String,
         text: Binding<String>,
         title: String? = nil,
         description: String? = nil) {
        self.placeholder = placeholder
        self._text = text
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
            HStack(alignment: .top,
                   spacing: 4) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.caption)
                Text(errorMessage)
                    .font(.caption)
            }
                   .foregroundColor(.red)
                   .transition(.opacity)
        } else {
            EmptyView()
        }
    }
    
    
    @ViewBuilder
    private var inputView: some View {
        Group {
            if isSecure {
                SecureField(placeholder,
                            text: $text)
            } else {
                TextField(placeholder,
                          text: $text)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .border(validationState.isInvalid ? Color.red : Color.clear, width: 2)
        .onChange(of: text) { oldValue, newValue in
            Task {
                self.validationState = await validationHandler?(newValue) ?? .unchanged
            }
        }
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
                .animation(.easeInOut(duration: 0.2),
                           value: validationState.isInvalid)
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

// MARK: - validationField

private struct FormFieldValidationHandler: EnvironmentKey {
    static var defaultValue: ((String) async -> ValidatedState)?
}

extension EnvironmentValues {
  var validationHandler: ((String) async -> ValidatedState)? {
    get { self[FormFieldValidationHandler.self] }
    set { self[FormFieldValidationHandler.self] = newValue }
  }
}

extension View {
    func onValidate(_ validationHandler: @escaping (String) async -> ValidatedState) -> some View {
        environment(\.validationHandler, validationHandler)
    }
}

// MARK: - Preview

#Preview {
    FormField("Email address", text: .constant("test@test.com"))
}

