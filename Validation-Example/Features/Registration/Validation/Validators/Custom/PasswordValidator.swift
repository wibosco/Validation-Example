//
//  PasswordValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//
import Foundation

struct PasswordValidator: Validator {
    
    // MARK: - Validator
    
    func validate(_ value: String) throws(PasswordValidationError) {
        // 1. Must have at least 8 characters
        guard value.count >= 8 else {
            throw .tooShort
        }
        
        // 2. Must have at most 24 characters
        guard value.count <= 24 else {
            throw .tooLong
        }
        
        // 3. Must have at least one lowercase character
        guard value.contains(where: { $0.isLowercase }) else {
            throw .missingLowercase
        }
        
        // 4. Must have at least one uppercase character
        guard value.contains(where: { $0.isUppercase }) else {
            throw .missingUppercase
        }
        
        // 5. Must have at least one number
        guard value.contains(where: { $0.isNumber }) else {
            throw .missingNumber
        }
        
        // 6. Must have at least one special character
        let allowedSpecialChars = CharacterSet(charactersIn: "&,_,-,@")
        let hasSpecialChar = value.unicodeScalars.contains { allowedSpecialChars.contains($0) }
        guard hasSpecialChar else {
            throw .missingSpecialCharacter
        }
    }
}
