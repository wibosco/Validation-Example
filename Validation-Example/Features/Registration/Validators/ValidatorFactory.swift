//
//  ValidatorFactory.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

protocol ValidatorFactory {
    func createEmailAddressValidator() -> any Validator<EmailValidationError>
    func createPasswordValidator() -> any Validator<PasswordValidationError>
}

struct DefaultValidatorFactory: ValidatorFactory {
    
    // MARK: - EmailAddress
    
    func createEmailAddressValidator() -> any Validator<EmailValidationError> {
        EmailAddressValidator()
    }
    
    // MARK: - Password
    
    func createPasswordValidator() -> any Validator<PasswordValidationError> {
        PasswordValidator()
    }
}
