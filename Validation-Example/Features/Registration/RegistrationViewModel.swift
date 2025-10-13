//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation

@Observable
@MainActor
final class RegistrationViewModel {
    var canSubmit: Bool {
        emailAddressViewModel.validationState.isValid &&
        passwordViewModel.validationState.isValid
    }
    
    var emailAddressViewModel: ValidationViewModel<AnyValidator<EmailValidationError>>
    var passwordViewModel: ValidationViewModel<AnyValidator<PasswordValidationError>>
    
    // MARK: - Init
    
    init(emailAddressValidator: AnyValidator<EmailValidationError>,
         passwordValidator: AnyValidator<PasswordValidationError>) {
        
        emailAddressViewModel = ValidationViewModel(validator: emailAddressValidator,
                                                    errorMapper: Self.mapToString)
        
        passwordViewModel = ValidationViewModel(validator: passwordValidator,
                                                errorMapper: Self.mapToString)
    }
    
    // MARK: - ErrorMapping
    
    private static func mapToString(_ error: EmailValidationError) -> String {
        switch error {
        case .invalidFormat:
            return "Email domain format is invalid"
        }
    }
    
    private static func mapToString(_ error: PasswordValidationError) -> String {
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
}
