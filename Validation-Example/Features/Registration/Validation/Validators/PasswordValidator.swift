//
//  PasswordValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//
import Foundation

enum PasswordValidationError: Error {
    case tooShort
    case tooLong
    case missingLowercase
    case missingUppercase
    case missingNumber
    case missingSpecialCharacter
}

struct PasswordValidator: Validator {
    
    // MARK: - Validator
    
    func validate(_ value: String) throws(PasswordValidationError) {
        guard value.count >= 8 else {
            throw PasswordValidationError.tooShort
        }
        
        guard value.count <= 24 else {
            throw PasswordValidationError.tooLong
        }
        
        guard value.contains(where: { $0.isLowercase }) else {
            throw PasswordValidationError.missingLowercase
        }
        
        guard value.contains(where: { $0.isUppercase }) else {
            throw PasswordValidationError.missingUppercase
        }
        
        guard value.contains(where: { $0.isNumber }) else {
            throw PasswordValidationError.missingNumber
        }
        
        let allowedSpecialChars = CharacterSet(charactersIn: "&,_,-,@")
        let hasSpecialChar = value.unicodeScalars.contains { allowedSpecialChars.contains($0) }
        
        guard hasSpecialChar else {
            throw PasswordValidationError.missingSpecialCharacter
        }
    }
}
