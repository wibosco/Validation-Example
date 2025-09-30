//
//  ValidatedFieldViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation
import Combine

class ValidatedFieldViewModel: ObservableObject {
    @Published var value: String = ""
    @Published var validationResult: ValidationResult = .valid
    @Published var showError: Bool = false
    
    let title: String
    let placeholder: String
    let instructions: String?
    
    let isSecure: Bool
    
    private let validator: Validator
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(title: String,
         placeholder: String,
         instructions: String? = nil,
         isSecure: Bool = false,
         validator: Validator) {
        self.title = title
        self.placeholder = placeholder
        self.instructions = instructions
        
        self.isSecure = isSecure
        
        self.validator = validator
        
        setupDebouncingValidation()
    }
    
    // MARK: - Debouncing
    
    private func setupDebouncingValidation() {
        $value
            .debounce(for: .milliseconds(500),
                      scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self = self else {
                    return
                }
                
                if !newValue.isEmpty {
                    self.validate()
                } else {
                    self.validationResult = .valid
                    self.showError = false
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Validation
    
    func validate() {
        validationResult = validator.validate(value)
        showError = !validationResult.isValid
    }
}
