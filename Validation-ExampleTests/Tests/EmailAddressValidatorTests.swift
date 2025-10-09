//
//  EmailAddressValidatorTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing

@testable import Validation_Example

struct EmailAddressValidatorTests {
    var sut: EmailAddressValidator!
    
    // MARK: - Init
    
    init() {
        self.sut = EmailAddressValidator()
    }
    
    // MARK: - Tests
    
    @Test("Given a valid email address, when it is validated, then no error is thrown")
    func validateValidEmailAddress() async throws {
        let emailAddress = "test@test.com"
        
        #expect(throws: Never.self) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an empty email address, when it is validated, then the `empty` error is thrown")
    func validateEmptyEmailAddress() async throws {
        let emailAddress = ""
        
        #expect(throws: EmailValidationError.empty) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's @ symbol, when it is validated, then the `invalidFormat` error is thrown")
    func validateEmailAddressWithMissingAtSymbol() async throws {
        let emailAddress = "testtest.com"
        
        #expect(throws: EmailValidationError.invalidFormat) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's username, when it is validated, then the `invalidFormat` error is thrown")
    func validateEmailAddressWithMissingUsername() async throws {
        let emailAddress = "@test.com"
        
        #expect(throws: EmailValidationError.invalidFormat) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's domain, when it is validated, then the `invalidFormat` error is thrown")
    func validateEmailAddressWithMissingDomain() async throws {
        let emailAddress = "test@"
        
        #expect(throws: EmailValidationError.invalidFormat) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing an invalid domain format, when it is validated, then the `invalidFormat` error is thrown")
    func validateEmailAddressWithAnInvalidDomainFormat() async throws {
        let emailAddress = "test@testcom"
        
        #expect(throws: EmailValidationError.invalidFormat) {
            try sut.validate(emailAddress)
        }
    }
}
