//
//  RegistrationView.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @Bindable var viewModel: RegistrationViewModel
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                emailAddressField
                passwordField
                
                Spacer()
                
                submitButton
            }
            .padding()
            .navigationTitle("Registration")
        }
    }
    
    private var emailAddressField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email Address")
                .styleAsInputFieldTitle()
            
            TextValidationField("Enter your email address",
                                text: $viewModel.emailAddressViewModel.value,
                                validationState: viewModel.emailAddressViewModel.validationState)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Password")
                .styleAsInputFieldTitle()
            
            SecureValidationField("Enter your password",
                                  text: $viewModel.passwordViewModel.value,
                                  validationState: viewModel.passwordViewModel.validationState)
                .textContentType(.newPassword)
            
            passwordRequirements
        }
    }
    
    private var passwordRequirements: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(systemName: "info.circle")
                .font(.caption)
            
            Text("""
                Password must:
                 - Be between 8 and 24 characters in length.
                 - Contain a lower case letter.
                 - Contain an upper case letter.
                 - Contain a number.
                 - Contain a special symbol from: "&, _, -, @".
                """)
            .font(.caption)
        }
        .foregroundColor(.secondary)
    }
    
    private var submitButton: some View {
        Button("Submit") {
            if viewModel.canSubmit {
                // Omitted submission code
            } else {
                // Omitted alert code
            }
        }
    }
}

extension View {
    func styleAsInputField() -> some View {
        self
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    func styleAsInputFieldTitle() -> some View {
        self
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
}

extension View {
    func validated(_ state: ValidatedState) -> some View {
        VStack(alignment: .leading,
               spacing: 6) {
            self
                .border(state.isInvalid ? Color.red : Color.clear, width: 2)
            
            if case let .invalid(errorMessage) = state {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(errorMessage)
                        .font(.caption)
                }
                       .foregroundColor(.red)
                       .transition(.opacity)
            }
        }
               .animation(.easeInOut(duration: 0.2),
                          value: state.isInvalid)
    }
}

#Preview {
    let emailAddressValidator = EmailAddressValidator()
    let passwordValidator = PasswordValidator()
    
    let emailAddressViewModel = DefaultValidationViewModel(defaultValue: "",
                                                           validator: emailAddressValidator)
        .eraseToAnyValidationViewModel()
    
    let passwordViewModel = DefaultValidationViewModel(defaultValue: "",
                                                       validator: passwordValidator)
        .eraseToAnyValidationViewModel()
    
    let viewModel = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel,
                                          passwordViewModel: passwordViewModel)
    
    RegistrationView(viewModel: viewModel)
}
