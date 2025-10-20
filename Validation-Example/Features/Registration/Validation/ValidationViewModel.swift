//
//  ValidationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

@MainActor
protocol ValidationViewModel<Value> {
    associatedtype Value: Sendable & Equatable
    var value: Value { get set }
    var validationState: ValidatedState { get }
}

@Observable
@MainActor
final class DefaultValidationViewModel<V: Validator>: ValidationViewModel {
    var value: V.Value {
        didSet {
            validateAfterDebouncing(value)
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
         debouncer: Debouncer = DefaultDebouncer(duration: .seconds(1))) {
        self.validator = validator
        self.errorMapper = errorMapper
        self.debouncer = debouncer
        self.defaultValue = defaultValue
        self.value = defaultValue
    }
    
    // MARK: - Validate
    
    private func validateAfterDebouncing(_ currentValue: Value) {
        Task {
            await debouncer.submit {
                await self.validate(currentValue)
            }
        }
    }
    
    private func validate(_ currentValue: V.Value) {
        guard currentValue != defaultValue else {
            validationState = .unchanged
            return
        }
        
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
    
    convenience init(defaultValue: Value,
                     validator: V,
                     debouncer: Debouncer = DefaultDebouncer(duration: .seconds(1))) where V.ValidationError: CustomStringConvertible {
        self.init(defaultValue: defaultValue,
                  validator: validator,
                  errorMapper: { $0.description },
                  debouncer: debouncer)
    }
}
