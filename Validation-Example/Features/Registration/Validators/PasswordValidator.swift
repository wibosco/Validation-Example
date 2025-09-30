//
//  PasswordValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//
import Foundation

struct PasswordValidator: Validator {
    
    // MARK: - Validator
    
    func validate(_ value: String) -> ValidationResult {
        // Check for min length
        guard value.count >= 8 else {
            return .invalid("Password must be at least 8 characters long")
        }
        
        // Check for max length
        guard value.count <= 24 else {
            return .invalid("Password must be at most 24 characters")
        }
        
        // Check for at least one lowercase letter
        guard value.contains(where: { $0.isLowercase }) else {
            return .invalid("Password must contain at least one lowercase letter")
        }
        
        // Check for at least one uppercase letter
        guard value.contains(where: { $0.isUppercase }) else {
            return .invalid("Password must contain at least one uppercase letter")
        }
        
        // Check for at least one number
        guard value.contains(where: { $0.isNumber }) else {
            return .invalid("Password must contain at least one number")
        }
        
        // Check for at least one special character from the allowed set
        let allowedSpecialChars = CharacterSet(charactersIn: "&,_,-,@")
        let hasSpecialChar = value.unicodeScalars.contains { allowedSpecialChars.contains($0) }
        
        guard hasSpecialChar else {
            return .invalid("Password must contain at least one special character (&, _, -, @)s")
        }
        
        return .valid
    }
}
