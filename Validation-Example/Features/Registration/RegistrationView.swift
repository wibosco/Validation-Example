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
        FormField("Enter your email address",
                  text: $viewModel.emailAddressViewModel.value,
                  title: "Email Address")
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .validationState(viewModel.emailAddressViewModel.validationState)
//        .onValidate(viewModel.emailAddressViewModel.validate)
    }
    
    private var passwordField: some View {
        FormField("Enter your password",
                  text: $viewModel.passwordViewModel.value,
                  title: "Enter your password",
                  description: """
                            Password must:
                            - Be between 8 and 24 characters in length.
                            - Contain a lower case letter.
                            - Contain an upper case letter.
                            - Contain a number.
                            - Contain a special symbol from: "&, _, -, @".
                    """)
        .textContentType(.newPassword)
        .isSecure()
        .validationState(viewModel.passwordViewModel.validationState)
//        .onValidate(viewModel.passwordViewModel.validate)
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
