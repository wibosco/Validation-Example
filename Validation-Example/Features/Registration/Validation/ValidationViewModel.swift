//
//  ValidationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

protocol ValidationViewModel<Value> {
    associatedtype Value: Equatable
    var value: Value { get set }
    var validationState: ValidatedState { get }
    
    func validate(_ currentValue: Value) -> ValidatedState
}

@Observable
final class DefaultValidationViewModel<V: Validator>: ValidationViewModel {
    var value: V.Value
    private let defaultValue: V.Value
    
    private(set) var validationState: ValidatedState = .unchanged
    
    private let validator: V
    private let errorMapper: ((V.ValidationError) -> (String))
    
    // MARK: - Init
    
    init(defaultValue: V.Value,
         validator: V,
         errorMapper: @escaping ((V.ValidationError) -> (String))) {
        self.validator = validator
        self.errorMapper = errorMapper
        self.defaultValue = defaultValue
        self.value = defaultValue
    }
    
    // MARK: - Validate
    
    func validate(_ currentValue: V.Value) -> ValidatedState {
        guard currentValue != defaultValue else {
            validationState = .unchanged
            return validationState
        }
        
        do {
            try validator.validate(currentValue)
            
            validationState = .valid
        } catch {
            let errorMessage = errorMapper(error)
            
            validationState = .invalid(errorMessage)
        }
        
        return validationState
    }
}

extension DefaultValidationViewModel {
    
    // MARK: - CustomStringConvertible Convenience
    
    convenience init(defaultValue: Value,
                     validator: V) where V.ValidationError: CustomStringConvertible {
        self.init(defaultValue: defaultValue,
                  validator: validator,
                  errorMapper: { $0.description })
    }
}
