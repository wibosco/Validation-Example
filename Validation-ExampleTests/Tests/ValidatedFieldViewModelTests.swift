//
//  ValidatedFieldViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing
import Combine

@testable import Validation_Example

struct ValidatedFieldViewModelTests {
    
    var validator: StubValidator<FakeLocalizedError>!
    
    // MARK: - Init
    
    init() {
        validator = StubValidator()
    }

    // MARK: - Tests
    
    @Test("Given a view model, when initialized, then title is correctly assigned")
    func titleAssigned() async throws {
        let title = "test_title"
        
        let sut = ValidatedFieldViewModel(title: title,
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)

        #expect(sut.title == title)
    }
    
    @Test("Given a view model, when initialized, then placeholder is correctly assigned")
    func placeholderAssigned() async throws {
        let placeholder = "test_placeholder"
        
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: placeholder,
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)

        #expect(sut.placeholder == placeholder)
    }
    
    @Test("Given a view model, when initialized, then placeholder is correctly assigned")
    func isSecureAssigned() async throws {
        let isSecure = false
        
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: isSecure,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)

        #expect(sut.isSecure == isSecure)
    }
    
    @Test("Given a view model, when initialized, then placeholder is correctly assigned")
    func instructionsAssigned() async throws {
        let instructions = "test_instructions"
        
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: instructions,
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)

        #expect(sut.instructions == instructions)
    }
    
    @Test("Given a view model, when value changes, then validation should happen on the new value")
    func valueChanging() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)
        let value = "test_value"
        sut.value = value
        
        #expect(validator.events == [.validate(value)])
    }
    
    @Test("Given a view model, when validation passes, then `error` should be nil")
    func validationPasses() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)
        
        validator.validationErrorResponse = nil
        
        sut.value = "test_value"
        
        #expect(sut.error == nil)
    }
    
    @Test("Given a view model, when validation fails, then `error` should be set with the validation error thrown")
    func validationFails() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)
        
        let error = FakeLocalizedError.test
        validator.validationErrorResponse = error
        
        sut.value = "test_value"
        
        #expect(sut.error == error)
    }
    
    @Test("Given a view model, when error is nil, then showError returns false")
    func showErrorFalse() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)
        
        sut.error = nil
        
        #expect(sut.showError == false)
    }
    
    @Test("Given a view model, when error is not nil, then showError returns true")
    func showErrorTrue() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: ImmediateScheduler.shared)
        
        sut.error = FakeLocalizedError.test
        
        #expect(sut.showError == true)
    }
}
