//
//  ValidatedFieldViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation
import Combine
import CombineSchedulers

class ValidatedFieldViewModel<V: Validator>: ObservableObject {
    enum ValidatedFieldState: Equatable {
        case empty
        case valid
        case invalid(V.ValidationError)
        
        var isValid: Bool {
            guard case .valid = self else {
                return false
            }
            
            return true
        }
        
        var isInvalid: Bool {
            guard case .invalid(_) = self else {
                return false
            }
            
            return true
        }
    }
    
    @Published var value: String = ""
    @Published var state: ValidatedFieldState = .empty
    
    let title: String
    let placeholder: String
    let instructions: String?
    
    let isSecure: Bool
    
    private let validator: V
    private let scheduler: AnySchedulerOf<RunLoop>
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(title: String,
         placeholder: String,
         instructions: String? = nil,
         isSecure: Bool = false,
         validator: V,
         scheduler: AnySchedulerOf<RunLoop> = .main) {
        self.title = title
        self.placeholder = placeholder
        self.instructions = instructions
        
        self.isSecure = isSecure
        
        self.validator = validator
        self.scheduler = scheduler
        
        setupAutomaticValidation()
    }
    
    // MARK: - Debouncing
    
    private func setupAutomaticValidation() {
        $value
            .debounce(for: .seconds(1),
                      scheduler: scheduler)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] newValue in
                guard !newValue.isEmpty else {
                    self?.state = .empty
                    return
                }
                
                self?.validate(newValue) // Need to pass `newValue` as `value` won't yet have been updated
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Validation
    
    private func validate(_ value: String) {
        do {
            try validator.validate(value)
            state = .valid
        } catch {
            state = .invalid(error)
        }
    }
}
