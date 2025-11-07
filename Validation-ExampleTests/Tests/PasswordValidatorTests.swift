//
//  PasswordValidatorTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing

@testable import Validation_Example

struct PasswordValidatorTests {
    var sut: PasswordValidator!
    
    // MARK: - Init
    
    init() {
        sut = PasswordValidator()
    }
    
    // MARK: - Tests
    
    @Test("Given a valid password with @ symbol, when it is validated, then no error is thrown")
    func validateValidPasswordWithAtSymbol() async throws {
        let password = "Test@123"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a valid password with & symbol, when it is validated, then no error is thrown")
    func validateValidPasswordWithAmpersandSymbol() async throws {
        let password = "Test&123"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a valid password with _ symbol, when it is validated, then no error is thrown")
    func validateValidPasswordWithUnderscoreSymbol() async throws {
        let password = "Test_123"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a valid password with - symbol, when it is validated, then no error is thrown")
    func validateValidPasswordWithDashSymbol() async throws {
        let password = "Test-123"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a valid password that is on the `tooShort` boundary, when it is validated, then no error is thrown")
    func validateValidPasswordOnTheTooShortBoundary() async throws {
        let password = "Test@123"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a valid password that is on the `tooLong` boundary, when it is validated, then no error is thrown")
    func validateValidPasswordOnTheTooLongBoundary() async throws {
        let password = "Test@1234567891011121314"
        
        #expect(throws: Never.self) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password that is too short, when it is validated, then the `tooShort` error is thrown")
    func validatePasswordThatIsTooShort() async throws {
        let password = "Test@1"
        
        #expect(throws: PasswordValidationError.tooShort) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password that is too long, when it is validated, then the `tooLong` error is thrown")
    func validatePasswordThatIsTooLong() async throws {
        let password = "Test@123456789101112131415"
        
        #expect(throws: PasswordValidationError.tooLong) {
            try sut.validate(password)
        }
    }
        
    @Test("Given a password that is missing a lowercase letter, when it is validated, then the `missingLowercase` error is thrown")
    func validatePasswordThatIsMissingALowercaseLetter() async throws {
        let password = "TEST@123"
        
        #expect(throws: PasswordValidationError.missingLowercase) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password that is missing an uppercase letter, when it is validated, then the `missingUppercase` error is thrown")
    func validatePasswordThatIsMissingAUppercaseLetter() async throws {
        let password = "test@123"
        
        #expect(throws: PasswordValidationError.missingUppercase) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password that is missing a number, when it is validated, then the `missingNumber` error is thrown")
    func validatePasswordThatIsMissingANumber() async throws {
        let password = "Test@test"
        
        #expect(throws: PasswordValidationError.missingNumber) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password that is missing a special symbol, when it is validated, then the `missingSpecialCharacter` error is thrown")
    func validatePasswordThatIsMissingASpecialCharacter() async throws {
        let password = "Test1234"
        
        #expect(throws: PasswordValidationError.missingSpecialCharacter) {
            try sut.validate(password)
        }
    }
    
    @Test("Given a password with a invalid special symbol, when it is validated, then the `missingSpecialCharacter` error is thrown")
    func validatePasswordThatHasAnInvalidSpecialCharacter() async throws {
        let password = "Test£1234"
        
        #expect(throws: PasswordValidationError.missingSpecialCharacter) {
            try sut.validate(password)
        }
    }
}
