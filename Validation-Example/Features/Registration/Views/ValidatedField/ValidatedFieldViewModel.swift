//
//  ValidatedFieldViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation
import Combine

class ValidatedFieldViewModel<V: Validator, S: Scheduler>: ObservableObject {
    @Published var value: String = ""
    @Published var error: V.ValidationError?
    
    var showError: Bool {
        error != nil
    }
    
    let title: String
    let placeholder: String
    let instructions: String?
    
    let isSecure: Bool
    
    private let validator: V
    private let scheduler: S
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(title: String,
         placeholder: String,
         instructions: String? = nil,
         isSecure: Bool = false,
         validator: V,
         scheduler: S = RunLoop.main) {
        self.title = title
        self.placeholder = placeholder
        self.instructions = instructions
        
        self.isSecure = isSecure
        
        self.validator = validator
        self.scheduler = scheduler
        
        setupDebouncingValidation()
    }
    
    // MARK: - Debouncing
    
    private func setupDebouncingValidation() {
        $value
            .debounce(for: .milliseconds(500),
                      scheduler: scheduler)
            .sink { [weak self] newValue in
                guard let self = self else {
                    return
                }
                
                if !newValue.isEmpty {
                    self.validate(newValue) // Need to pass `newValue` as value won't yet have been updated
                } else {
                    self.error = nil
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Validation
    
    private func validate(_ value: String) {
        do {
            try validator.validate(value)
            error = nil
        } catch {
            self.error = error
        }
    }
}
