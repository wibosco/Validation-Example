//
//  Validator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation

protocol Validator {
    func validate(_ value: String) -> ValidationResult
}

enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        if case .valid = self {
            return true
        }
        
        return false
    }
    
    var errorMessage: String? {
        if case .invalid(let message) = self {
            return message
        }
        
        return nil
    }
}
