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

class RegistrationViewModel: ObservableObject {
    var canSubmit: Bool {
        emailAddressState.isValid &&
        passwordState.isValid
    }
    
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    
    @Published private(set) var emailAddressState: ValidatedState = .empty
    @Published private(set) var passwordState: ValidatedState = .empty
    
    private let validatorFactory: ValidatorFactory
    private let scheduler: AnySchedulerOf<RunLoop>
    
    // MARK: - Init
    
    init(validatorFactory: ValidatorFactory = DefaultValidatorFactory(),
         scheduler: AnySchedulerOf<RunLoop> = .main) {
        self.validatorFactory = validatorFactory
        self.scheduler = scheduler
        
        subscribeToEmailAddressUpdates()
        subscribeToPasswordUpdates()
    }
    
    // MARK: - DebouncePublisher
    
    private func subscribeToEmailAddressUpdates() {
        let validator = validatorFactory.createEmailAddressValidator()
        
        createPublisher($emailAddress,
                        validator: validator) { error in
            switch error {
            case .invalidFormat:
                return "Email domain format is invalid"
            }
        }
        .assign(to: &$emailAddressState)
    }
    
    private func subscribeToPasswordUpdates() {
        let validator = validatorFactory.createPasswordValidator()
        
        createPublisher($password,
                        validator: validator) { error in
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
        .assign(to: &$passwordState)
    }
    
    private func createPublisher<V: Validator>(_ value: Published<String>.Publisher,
                                               validator: V,
                                               errorMapper: @escaping (V.ValidationError) -> (String)) -> AnyPublisher<ValidatedState, Never> {
        value
            .debounce(for: .seconds(1),
                      scheduler: scheduler)
            .removeDuplicates()
            .map { newValue in
                guard !newValue.isEmpty else {
                    return .empty
                }
                
                do {
                    try validator.validate(newValue)
                    return .valid
                } catch let error as V.ValidationError {
                    let errorMessage = errorMapper(error)
                    
                    return .invalid(errorMessage)
                } catch { // `.map` is earsing the typed throw
                    return .invalid("Unknown error")
                }
            }
            .eraseToAnyPublisher()
    }
}
