//
//  StubValidatorFactory.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

@testable import Validation_Example

final class StubValidatorFactory: ValidatorFactory {
    enum Event: Equatable {
        case createEmailAddressValidator
        case createPasswordValidator
    }
    
    private(set) var events = [Event]()
    
    var emailAddressValidatorToReturn: (any Validator<EmailValidationError>)!
    var passwordValidatorToReturn: (any Validator<PasswordValidationError>)!
    
    func createEmailAddressValidator() -> any Validator<EmailValidationError> {
        emailAddressValidatorToReturn
    }
    
    func createPasswordValidator() -> any Validator<PasswordValidationError> {
        passwordValidatorToReturn
    }
}
