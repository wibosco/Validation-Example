//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CombineSchedulers

@Observable
@MainActor
final class RegistrationViewModel {
    var canSubmit: Bool {
        emailAddressState.isValid &&
        passwordState.isValid
    }
    
    var emailAddress: String = "" {
        didSet {
            Task { @MainActor in
                await debouncer.submit(key: "EmailAddressValidation") {
                    await self.validateEmailAddress()
                }
            }
        }
    }
    
    var password: String = "" {
        didSet {
            Task { @MainActor in
                await debouncer.submit(key: "PasswordValidation") {
                    await self.validatePassword()
                }
            }
        }
    }
    
    private(set) var emailAddressState: ValidatedState = .empty
    private(set) var passwordState: ValidatedState = .empty
    
    private let validatorFactory: ValidatorFactory
    private let debouncer: Debouncer
    
    // MARK: - Init
    
    init(validatorFactory: ValidatorFactory = DefaultValidatorFactory(),
         debouncer: Debouncer = DefaultDebouncer.validationDebouncer) {
        self.validatorFactory = validatorFactory
        self.debouncer = debouncer
    }
    
    // MARK: - Validate
    
    private func validateEmailAddress() {
        guard !emailAddress.isEmpty else {
            emailAddressState = .empty
            return
        }
        
        let validator = validatorFactory.createEmailAddressValidator()
        
        do {
            try validator.validate(emailAddress)
                
            emailAddressState = .valid
        } catch {
            let errorMessage: String
            switch error {
            case .invalidFormat:
                errorMessage = "Email domain format is invalid"
            }
            
            emailAddressState = .invalid(errorMessage)
        }
    }
    
    private func validatePassword() {
        guard !password.isEmpty else {
            passwordState = .empty
            return
        }
        
        let validator = validatorFactory.createPasswordValidator()
        
        do {
            try validator.validate(password)
                
            passwordState = .valid
        } catch {
            let errorMessage: String
            switch error {
            case .tooShort:
                errorMessage = "Password must be at least 8 characters long"
            case .tooLong:
                errorMessage = "Password must be at most 24 characters"
            case .missingLowercase:
                errorMessage = "Password must contain at least one lowercase letter"
            case .missingUppercase:
                errorMessage = "Password must contain at least one uppercase letter"
            case .missingNumber:
                errorMessage = "Password must contain at least one number"
            case .missingSpecialCharacter:
                errorMessage = "Password must contain at least one special character (&, _, -, @)"
            }
            
            passwordState = .invalid(errorMessage)
        }
    }
}
