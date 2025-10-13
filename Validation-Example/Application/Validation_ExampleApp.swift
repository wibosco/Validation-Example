//
//  ModelingFormChanges_ExampleApp.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import SwiftUI

@main
struct ModelingFormChanges_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            let emailAddressValidator = EmailAddressValidator()
            let passwordValidator = PasswordValidator()
            
            let viewModel = RegistrationViewModel(emailAddressValidator: emailAddressValidator.eraseToAnyValidator(),
                                                  passwordValidator: passwordValidator.eraseToAnyValidator())
            
            RegistrationView(viewModel: viewModel)
        }
    }
}
