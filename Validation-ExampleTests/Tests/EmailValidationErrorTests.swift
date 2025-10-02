//
//  EmailValidationErrorTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing

@testable import Validation_Example

struct EmailValidationErrorTests {
    
    // MARK: - Tests
    
    @Test("Given an `empty` error, when errorDescription is called, then a localised string is returned")
    func localisedEmptyError() async throws {
        let error = EmailValidationError.empty
        
        #expect(error.errorDescription == "Email address cannot be empty")
    }
    
    @Test("Given an `invalidFormat` error, when errorDescription is called, then a localised string is returned")
    func localisedInvalidFormatError() async throws {
        let error = EmailValidationError.invalidFormat
        
        #expect(error.errorDescription == "Email domain format is invalid")
    }
}
