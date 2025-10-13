//
//  ValidationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

@Observable
@MainActor
final class ValidationViewModel<V: Validator> {
    var value: String = "" {
        didSet {
            let currentValue = value
            Task { @MainActor in
                await debouncer.submit(key: uuid) {
                    await self.validate(currentValue)
                }
            }
        }
    }
    
    private(set) var validationState: ValidatedState = .empty
    
    private let validator: V
    private let errorMapper: ((V.ValidationError) -> (String))
    private let debouncer: Debouncer
    private let uuid = UUID().uuidString
    
    // MARK: - Init
    
    init(validator: V,
         errorMapper: @escaping ((V.ValidationError) -> (String)),
         debouncer: Debouncer = DefaultDebouncer.validationDebouncer) {
        self.validator = validator
        self.errorMapper = errorMapper
        self.debouncer = debouncer
    }
    
    // MARK: - Validate
    
    private func validate(_ currentValue: String) {
        guard !currentValue.isEmpty else {
            validationState = .empty
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
