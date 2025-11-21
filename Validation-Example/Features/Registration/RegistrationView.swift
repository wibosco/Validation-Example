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
    
    private var emailAddressFieldView: some View {
        ValidationInputField(title: "Email Address",
                  placeholder: "Enter your email address",
                  value: $viewModel.emailAddressViewModel.value)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .validationState(viewModel.emailAddressViewModel.validationState)
    }
    
    private var passwordFieldView: some View {
        ValidationInputField(title: "Enter your password",
                  placeholder: "Enter your password",
                  value: $viewModel.passwordViewModel.value)
        .textContentType(.newPassword)
        .isSecure()
        .validationState(viewModel.passwordViewModel.validationState)
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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                emailAddressFieldView
                passwordFieldView
                
                Spacer()
                
                submitButton
            }
            .padding()
            .navigationTitle("Registration")
        }
    }
}

#Preview {
    let emailAddressValidator = EmailAddressValidator()
    let passwordValidator = PasswordValidator()
    
    let emailAddressViewModel = DefaultValidationViewModel(validator: emailAddressValidator)
        .eraseToAnyValidationViewModel()
    
    let passwordViewModel = DefaultValidationViewModel(validator: passwordValidator)
        .eraseToAnyValidationViewModel()
    
    let viewModel = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel,
                                          passwordViewModel: passwordViewModel)
    
    RegistrationView(viewModel: viewModel)
}
