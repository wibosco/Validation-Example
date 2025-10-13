//
//  Validator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation

protocol Validator<ValidationError> {
    associatedtype ValidationError: Error
    func validate(_ value: String) throws(ValidationError)
}

extension Validator {
    func eraseToAnyValidator() -> AnyValidator<ValidationError> {
        AnyValidator(self)
    }
}

struct AnyValidator<ValidationError: Error>: Validator {
    private let _validate: (String) throws(ValidationError) -> Void

    // MARK: - Init
    
    init<V: Validator>(_ validator: V) where V.ValidationError == ValidationError {
        self._validate = validator.validate
    }
    
    // MARK: - Validate

    func validate(_ value: String) throws(ValidationError) {
        try _validate(value)
    }
}
