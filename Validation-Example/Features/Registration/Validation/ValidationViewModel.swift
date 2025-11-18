//
//  ValidationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

@MainActor
protocol ValidationViewModel<Value> {
    associatedtype Value: Equatable
    var value: Value { get set }
    var validationState: ValidatedState { get }
}

@Observable
final class DefaultValidationViewModel<V: Validator>: ValidationViewModel {
    var value: V.Value {
        didSet {
            guard value != initialValue else {
                validationState = .unchanged

                return
            }
            
            debouncer {
                self.validate(self.value)
            }
        }
    }
    
    private(set) var validationState: ValidatedState = .unchanged
    
    private let validator: V
    private let errorMapper: ((V.ValidationError) -> (String))
    private let debouncer: Debouncer
    private let initialValue: V.Value
    
    // MARK: - Init
    
    init(initialValue: V.Value,
         validator: V,
         errorMapper: @escaping ((V.ValidationError) -> (String)),
         debouncer: Debouncer = DefaultDebouncer(delay: .milliseconds(500))) {
        self.value = initialValue
        self.initialValue = initialValue
        self.validator = validator
        self.errorMapper = errorMapper
        self.debouncer = debouncer
    }
    
    // MARK: - Validate
    
    private func validate(_ currentValue: V.Value) {
        do {
            try validator.validate(currentValue)
            
            validationState = .valid
        } catch {
            let errorMessage = errorMapper(error)
            
            validationState = .invalid(errorMessage)
        }
    }
}

extension DefaultValidationViewModel {
    
    // MARK: - Convenience
    
    convenience init(validator: V) where V.Value == String, V.ValidationError: LocalizedError {
        self.init(initialValue: "",
                  validator: validator,
                  errorMapper: { $0.errorDescription ?? "Unknown error" })
    }
}
