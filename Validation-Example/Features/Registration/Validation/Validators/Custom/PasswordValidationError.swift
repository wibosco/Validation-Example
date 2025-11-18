//
//  PasswordValidationError.swift
//  Validation-Example
//
//  Created by William Boles on 20/10/2025.
//

import Foundation

enum PasswordValidationError: Error, Equatable, LocalizedError {
    case tooShort
    case tooLong
    case missingLowercase
    case missingUppercase
    case missingNumber
    case missingSpecialCharacter
    
    // MARK: - LocalizedError
    
    var errorDescription: String? {
        switch self {
        case .tooShort:
            return "Password must be at least 8 characters long."
        case .tooLong:
            return "Password must be at most 24 characters long."
        case .missingLowercase:
            return "Password must contain at least one lowercase letter."
        case .missingUppercase:
            return "Password must contain at least one uppercase letter."
        case .missingNumber:
            return "Password must contain at least one number."
        case .missingSpecialCharacter:
            return "Password must contain a special character (&, _, -, @)."
        }
    }
}
