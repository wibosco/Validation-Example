//
//  PasswordValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//
import Foundation

struct PasswordValidator: Validator {
    
    // MARK: - Validator
    
    func validate(_ value: String) async throws(PasswordValidationError) {
        guard value.count >= 8 else {
            throw .tooShort
        }
        
        guard value.count <= 24 else {
            throw .tooLong
        }
        
        guard value.contains(where: { $0.isLowercase }) else {
            throw .missingLowercase
        }
        
        guard value.contains(where: { $0.isUppercase }) else {
            throw .missingUppercase
        }
        
        guard value.contains(where: { $0.isNumber }) else {
            throw .missingNumber
        }
        
        let allowedSpecialChars = CharacterSet(charactersIn: "&,_,-,@")
        let hasSpecialChar = value.unicodeScalars.contains { allowedSpecialChars.contains($0) }
        
        guard hasSpecialChar else {
            throw .missingSpecialCharacter
        }
    }
}
