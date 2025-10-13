//
//  ValidatedState.swift
//  Validation-Example
//
//  Created by William Boles on 10/10/2025.
//

enum ValidatedState: Equatable {
    case empty
    case valid
    case invalid(String)
    
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
