//
//  RegistrationViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 13/10/2025.
//

import Testing
import Foundation
import Combine
import CombineSchedulers

@testable import Validation_Example

struct RegistrationViewModelTests {
    var validatorFactory: StubValidatorFactory!
    var scheduler: TestSchedulerOf<RunLoop>!
    
    // MARK: - Init
    
    init() {
        validatorFactory = StubValidatorFactory()
        scheduler = RunLoop.test
    }
    
    // MARK: - Tests
    
    @Test("Given a view model, when `emailAddress` value changes, then validation should happen on the new value")
    func emailAddressValueChange() async throws {
        let validator = StubValidator<EmailValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = validator
        validatorFactory.passwordValidatorToReturn = StubValidator<PasswordValidationError>()
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        let value = "test_value"
        sut.emailAddress = value
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(validator.events == [.validate(value)])
    }
    
    @Test("Given a view model, when `emailAddress` value is passes validation, then `state` is set to `valid`")
    func emailAddressPassesValidation() async throws {
        let validator = StubValidator<EmailValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = validator
        validatorFactory.passwordValidatorToReturn = StubValidator<PasswordValidationError>()
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.emailAddressState == .valid)
    }
    
    @Test("Given a view model, when `password` value is fails validation, then `state` is set to `invalid`",
          arguments: zip(
            [
                .invalidFormat,
            ] as [EmailValidationError],
            [
                "Email domain format is invalid"
            ]
          )
    )
    func emailAddressFailsValidationWithInvalidFormat(error: EmailValidationError,
                                                      message: String) async throws {
        let validator = StubValidator<EmailValidationError>()
        validator.validateResponse = .failure(error)
        
        validatorFactory.emailAddressValidatorToReturn = validator
        validatorFactory.passwordValidatorToReturn = StubValidator<PasswordValidationError>()
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.emailAddressState == .invalid(message))
    }
    
    @Test("Given `emailAddressState` value is valid, when `emailAddress` is set to an empty string, then `state` is set to `empty`")
    func emailAddressStateIsEmptyForEmptyValue() async throws {
        let validator = StubValidator<EmailValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = validator
        validatorFactory.passwordValidatorToReturn = StubValidator<PasswordValidationError>()
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.emailAddressState == .valid)
        
        sut.emailAddress = ""
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.emailAddressState == .empty)
    }
    
    @Test("Given a view model, when `password` value changes, then validation should happen on the new value")
    func passwordValueChange() async throws {
        let validator = StubValidator<PasswordValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = StubValidator<EmailValidationError>()
        validatorFactory.passwordValidatorToReturn = validator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        let value = "test_value"
        sut.password = value
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(validator.events == [.validate(value)])
    }
    
    @Test("Given a view model, when `password` value is passes validation, then `state` is set to `valid`")
    func passwordPassesValidation() async throws {
        let validator = StubValidator<PasswordValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = StubValidator<EmailValidationError>()
        validatorFactory.passwordValidatorToReturn = validator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.passwordState == .valid)
    }
    
    @Test("Given a view model, when `password` value is fails validation, then `state` is set to `invalid`",
          arguments: zip(
            [
                .tooShort,
                .tooLong,
                .missingLowercase,
                .missingUppercase,
                .missingNumber,
                .missingSpecialCharacter
            ] as [PasswordValidationError],
            [
                "Password must be at least 8 characters long",
                "Password must be at most 24 characters",
                "Password must contain at least one lowercase letter",
                "Password must contain at least one uppercase letter",
                "Password must contain at least one number",
                "Password must contain at least one special character (&, _, -, @)"
            ]
          )
    )
    func passwordFailsValidation(error: PasswordValidationError,
                                 message: String) async throws {
        let validator = StubValidator<PasswordValidationError>()
        validator.validateResponse = .failure(error)
        
        validatorFactory.emailAddressValidatorToReturn = StubValidator<EmailValidationError>()
        validatorFactory.passwordValidatorToReturn = validator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.passwordState == .invalid(message))
    }
    
    @Test("Given `passwordState` value is valid, when `password` is set to an empty string, then `state` is set to `empty`")
    func passwordStateIsEmptyForEmptyValue() async throws {
        let validator = StubValidator<PasswordValidationError>()
        validator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = StubValidator<EmailValidationError>()
        validatorFactory.passwordValidatorToReturn = validator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.passwordState == .valid)
        
        sut.password = ""
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.passwordState == .empty)
    }
    
    @Test("Given all fields are valid, when `canSubmit` is called, then `true` is returned")
    func canSubmitIsTrueWhenAllFieldsAreValid() async throws {
        let emailAddressValidator = StubValidator<EmailValidationError>()
        emailAddressValidator.validateResponse = .success(Void())
        
        let passwordValidator = StubValidator<PasswordValidationError>()
        passwordValidator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = emailAddressValidator
        validatorFactory.passwordValidatorToReturn = passwordValidator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.canSubmit == true)
    }
    
    @Test("Given `emailAddress` isn't valid but other fields are `valid`, when `canSubmit` is called, then `false` is returned")
    func canSubmitIsFalseWhenEmailAddressFieldIsNotValid() async throws {
        let emailAddressValidator = StubValidator<EmailValidationError>()
        emailAddressValidator.validateResponse = .failure(.invalidFormat)
        
        let passwordValidator = StubValidator<PasswordValidationError>()
        passwordValidator.validateResponse = .success(Void())
        
        validatorFactory.emailAddressValidatorToReturn = emailAddressValidator
        validatorFactory.passwordValidatorToReturn = passwordValidator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.canSubmit == false)
    }
    
    @Test("Given `password` isn't valid but other fields are `valid`, when `canSubmit` is called, then `false` is returned")
    func canSubmitIsFalseWhenPasswordFieldIsNotValid() async throws {
        let emailAddressValidator = StubValidator<EmailValidationError>()
        emailAddressValidator.validateResponse = .success(Void())
        
        let passwordValidator = StubValidator<PasswordValidationError>()
        passwordValidator.validateResponse = .failure(.missingLowercase)
        
        validatorFactory.emailAddressValidatorToReturn = emailAddressValidator
        validatorFactory.passwordValidatorToReturn = passwordValidator
        
        let sut = RegistrationViewModel(validatorFactory: validatorFactory,
                                        scheduler: scheduler.eraseToAnyScheduler())
        
        sut.emailAddress = "test_value"
        sut.password = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.canSubmit == false)
    }
}
