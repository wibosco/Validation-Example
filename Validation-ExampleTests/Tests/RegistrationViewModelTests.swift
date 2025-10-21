//
//  RegistrationViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 13/10/2025.
//

import Testing
import Foundation

@testable import Validation_Example

@MainActor
struct RegistrationViewModelTests {
    var emailAddressViewModel: StubValidationViewModel!
    var passwordViewModel: StubValidationViewModel!
    
    var sut: RegistrationViewModel!
    
    // MARK: - Init
    
    init() {
        emailAddressViewModel = StubValidationViewModel()
        passwordViewModel = StubValidationViewModel()
        
        sut = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel.eraseToAnyValidationViewModel(),
                                    passwordViewModel: passwordViewModel.eraseToAnyValidationViewModel())
    }
    
    // MARK: - Tests

    @Test("Given all fields are valid, when `canSubmit` is called, then `true` is returned")
    func canSubmitIsTrueWhenAllFieldsAreValid() async throws {
        emailAddressViewModel.validationState = .valid
        passwordViewModel.validationState = .valid
        
        #expect(sut.canSubmit == true)
    }
    
    @Test("Given `emailAddress` isn't valid but other fields are `valid`, when `canSubmit` is called, then `false` is returned")
    func canSubmitIsFalseWhenEmailAddressFieldIsNotValid() async throws {
        emailAddressViewModel.validationState = .invalid("test_error")
        passwordViewModel.validationState = .valid
        
        #expect(sut.canSubmit == false)
    }
    
    @Test("Given `password` isn't valid but other fields are `valid`, when `canSubmit` is called, then `false` is returned")
    func canSubmitIsFalseWhenPasswordFieldIsNotValid() async throws {
        emailAddressViewModel.validationState = .valid
        passwordViewModel.validationState = .invalid("test_error")
        
        #expect(sut.canSubmit == false)
    }
}
