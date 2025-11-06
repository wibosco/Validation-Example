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
        let emailAddress = "te.st@test.com"
        
        #expect(throws: Never.self) {
            try sut.validate(emailAddress)
        }
    }

    @Test("Given an email address isjust whitespace, when it is validated, then the `empty` error is thrown")
    func validateEmailAddressWithOnlyWhiteSpace() async throws {
        let emailAddress = "    "
        
        #expect(throws: EmailAddressValidationError.empty) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's @ symbol, when it is validated, then the `missingAtSign` error is thrown")
    func validateEmailAddressWithMissingAtSymbol() async throws {
        let emailAddress = "testtest.com"
        
        #expect(throws: EmailAddressValidationError.missingAtSign) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address with two @ symbols, when it is validated, then the `multipleAtSigns` error is thrown")
    func validateEmailAddressWithMultipleAySymbols() async throws {
        let emailAddress = "test@te@st.com"
        
        #expect(throws: EmailAddressValidationError.multipleAtSigns) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's username, when it is validated, then the `noLocalPart` error is thrown")
    func validateEmailAddressWithMissingUsername() async throws {
        let emailAddress = "@test.com"
        
        #expect(throws: EmailAddressValidationError.noLocalPart) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing it's domain, when it is validated, then the `noDomainPart` error is thrown")
    func validateEmailAddressWithMissingDomain() async throws {
        let emailAddress = "test@"
        
        #expect(throws: EmailAddressValidationError.noDomainPart) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing invalid characters, when it is validated, then the `invalidLocalCharacters` error is thrown")
    func validateEmailAddressWithInvalidCharactersInLocal() async throws {
        let emailAddress = "te!st@test.com"
        
        #expect(throws: EmailAddressValidationError.invalidLocalCharacters("!")) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing invalid characters, when it is validated, then the `localStartsOrEndsWithDot` error is thrown")
    func validateEmailAddressStartsWithADot() async throws {
        let emailAddress = ".test@test.com"
        
        #expect(throws: EmailAddressValidationError.localStartsOrEndsWithDot) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing invalid characters, when it is validated, then the `localStartsOrEndsWithDot` error is thrown")
    func validateEmailAddressEndsWithADot() async throws {
        let emailAddress = "test.@test.com"
        
        #expect(throws: EmailAddressValidationError.localStartsOrEndsWithDot) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing invalid characters, when it is validated, then the `consecutiveDots` error is thrown")
    func validateEmailAddressEndsWithConsecutiveDots() async throws {
        let emailAddress = "te..st@test.com"
        
        #expect(throws: EmailAddressValidationError.consecutiveDots) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing an invalid domain format, when it is validated, then the `domainTooShort` error is thrown")
    func validateEmailAddressWithDomainBeingTooShort() async throws {
        let emailAddress = "test@testcom"
        
        #expect(throws: EmailAddressValidationError.domainTooShort) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing an invalid domain format, when it is validated, then the `invalidDomainLabel` error is thrown")
    func validateEmailAddressWithInvalidCharactersInDomain() async throws {
        let emailAddress = "test@test.c!om"
        
        #expect(throws: EmailAddressValidationError.invalidDomainLabel("c!om")) {
            try sut.validate(emailAddress)
        }
    }
    
    @Test("Given an email address missing an invalid domain format, when it is validated, then the `invalidTopLevelDomain` error is thrown")
    func validateEmailAddressWithTLDBeingTooShort() async throws {
        let emailAddress = "test@test.c"
        
        #expect(throws: EmailAddressValidationError.invalidTopLevelDomain("c")) {
            try sut.validate(emailAddress)
        }
    }
}
