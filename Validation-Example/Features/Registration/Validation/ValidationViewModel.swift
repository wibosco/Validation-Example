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
final class DefaultValidationViewModel<V: Validator, Value: Sendable & Equatable>: ValidationViewModel where Value == V.Value {
    var value: Value {
        didSet {
            let currentValue = value
            Task { @MainActor in
                await debouncer.submit {
                    await self.validate(currentValue)
                }
            }
        }
    }
    private let defaultValue: Value
    
    private(set) var validationState: ValidatedState = .untouched
    
    private let validator: V
    private let errorMapper: ((V.ValidationError) -> (String))
    private let debouncer: Debouncer
    
    // MARK: - Init
    
    init(defaultValue: Value,
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
    
    private func validate(_ currentValue: Value) {
        guard currentValue != defaultValue else {
            validationState = .untouched
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

@Observable
@MainActor
final class AnyValidationViewModel<Value: Sendable & Equatable>: ValidationViewModel {
    private var wrappedViewModel: any ValidationViewModel<Value>
    
    var value: Value {
        get { wrappedViewModel.value }
        set { wrappedViewModel.value = newValue }
    }
    
    var validationState: ValidatedState {
        wrappedViewModel.validationState
    }
    
    init<VM: ValidationViewModel>(_ viewModel: VM) where VM.Value == Value {
        self.wrappedViewModel = viewModel
    }
}

extension ValidationViewModel {
    func eraseToAnyValidationViewModel() -> AnyValidationViewModel<Value> {
        AnyValidationViewModel(self)
    }
}
