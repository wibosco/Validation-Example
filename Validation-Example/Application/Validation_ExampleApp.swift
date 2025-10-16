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
            
            let emailAddressViewModel = DefaultValidationViewModel(validator: emailAddressValidator) { error in
                switch error {
                case .invalidFormat:
                    return "Email address format is invalid"
                }
            }
                
            let passwordViewModel = DefaultValidationViewModel(validator: passwordValidator) { error in
                switch error {
                case .tooShort:
                    return "Password must be at least 8 characters long"
                case .tooLong:
                    return "Password must be at most 24 characters"
                case .missingLowercase:
                    return "Password must contain at least one lowercase letter"
                case .missingUppercase:
                    return "Password must contain at least one uppercase letter"
                case .missingNumber:
                    return "Password must contain at least one number"
                case .missingSpecialCharacter:
                    return "Password must contain at least one special character (&, _, -, @)"
                }
            }
            
            let viewModel = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel,
                                                  passwordViewModel: passwordViewModel)
            
            RegistrationView(viewModel: viewModel)
        }
    }
}
