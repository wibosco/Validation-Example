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
            guard value != defaultValue else {
                validationState = .unchanged

                return
            }
            
            debouncer {
                self.validate(self.value)
            }
        }
    }
    private let defaultValue: V.Value
    
    private(set) var validationState: ValidatedState = .unchanged
    
    private let validator: V
    private let errorMapper: ((V.ValidationError) -> (String))
    private let debouncer: Debouncer
    
    // MARK: - Init
    
    init(defaultValue: V.Value,
         validator: V,
         errorMapper: @escaping ((V.ValidationError) -> (String)),
         debouncer: Debouncer = DefaultDebouncer(delay: .milliseconds(500))) {
        self.validator = validator
        self.errorMapper = errorMapper
        self.debouncer = debouncer
        self.defaultValue = defaultValue
        self.value = defaultValue
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
    
    // MARK: - CustomStringConvertible Convenience
    
    convenience init(defaultValue: V.Value,
                     validator: V) where V.ValidationError: CustomStringConvertible {
        self.init(defaultValue: defaultValue,
                  validator: validator,
                  errorMapper: { $0.description })
    }
}
