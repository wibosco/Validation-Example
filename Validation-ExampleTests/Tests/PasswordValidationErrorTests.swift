//
//  PasswordValidationErrorTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing

@testable import Validation_Example

struct PasswordValidationErrorTests {
    
    // MARK: - Tests
    
    @Test("Given an `tooShort` error, when errorDescription is called, then a localised string is returned")
    func localisedTooShortError() async throws {
        let error = PasswordValidationError.tooShort
        
        #expect(error.errorDescription == "Password must be at least 8 characters long")
    }
    
    @Test("Given an `tooLong` error, when errorDescription is called, then a localised string is returned")
    func localisedTooLongError() async throws {
        let error = PasswordValidationError.tooLong
        
        #expect(error.errorDescription == "Password must be at most 24 characters")
    }
    
    @Test("Given an `missingLowercase` error, when errorDescription is called, then a localised string is returned")
    func localisedMissingLowercaseError() async throws {
        let error = PasswordValidationError.missingLowercase
        
        #expect(error.errorDescription == "Password must contain at least one lowercase letter")
    }
    
    @Test("Given an `missingUppercase` error, when errorDescription is called, then a localised string is returned")
    func localisedMissingUppercaseError() async throws {
        let error = PasswordValidationError.missingUppercase
        
        #expect(error.errorDescription == "Password must contain at least one uppercase letter")
    }
    
    @Test("Given an `missingNumber` error, when errorDescription is called, then a localised string is returned")
    func localisedMissingNumberError() async throws {
        let error = PasswordValidationError.missingNumber
        
        #expect(error.errorDescription == "Password must contain at least one number")
    }
    
    @Test("Given an `missingSpecialCharacter` error, when errorDescription is called, then a localised string is returned")
    func localisedMissingSpecialCharacterError() async throws {
        let error = PasswordValidationError.missingSpecialCharacter
        
        #expect(error.errorDescription == "Password must contain at least one special character (&, _, -, @)")
    }
}
