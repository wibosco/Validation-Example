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
            
            let emailAddressViewModel = DefaultValidationViewModel(validator: emailAddressValidator)
                
            let passwordViewModel = DefaultValidationViewModel(validator: passwordValidator)
            
            let viewModel = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel.eraseToAnyValidationViewModel(),
                                                  passwordViewModel: passwordViewModel.eraseToAnyValidationViewModel())
            
            RegistrationView(viewModel: viewModel)
        }
    }
}
