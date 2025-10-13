//
//  EmailAddressValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation

enum EmailValidationError: Error {
    case invalidFormat
}

struct EmailAddressValidator: Validator {

    // MARK: - Validator
    
    func validate(_ value: String) throws(EmailValidationError) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Basic format check using regex
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: trimmedValue) else {
            throw EmailValidationError.invalidFormat
        }
    }
}
