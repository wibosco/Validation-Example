//
//  ValidatedFieldViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Testing
import Foundation
import Combine
import CombineSchedulers

@testable import Validation_Example

struct ValidatedFieldViewModelTests {
    var validator: StubValidator<FakeLocalizedError>!
    var scheduler: TestSchedulerOf<RunLoop>!
    
    // MARK: - Init
    
    init() {
        validator = StubValidator()
        scheduler = RunLoop.test
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
                                          scheduler: scheduler.eraseToAnyScheduler())

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
                                          scheduler: scheduler.eraseToAnyScheduler())

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
                                          scheduler: scheduler.eraseToAnyScheduler())

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
                                          scheduler: scheduler.eraseToAnyScheduler())

        #expect(sut.instructions == instructions)
    }
    
    @Test("Given a view model, when value changes, then validation should happen on the new value")
    func valueChanging() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: scheduler.eraseToAnyScheduler())
        let value = "test_value"
        sut.value = value
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(validator.events == [.validate(value)])
    }
    
    @Test("Given a view model, when value changes, then validation should only happen after debouncing of 500 milliseconds")
    func debouncing() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: scheduler.eraseToAnyScheduler())
        let value = "test_value"
        sut.value = value
        
        await scheduler.advance(by: .milliseconds(999))
        
        #expect(validator.events.isEmpty)
        
        await scheduler.advance(by: .milliseconds(1))
        
        #expect(validator.events == [.validate(value)])
    }
    
    @Test("Given a view model, when validation passes, then `error` should be nil")
    func validationPasses() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: scheduler.eraseToAnyScheduler())
        
        validator.validationErrorResponse = nil
        
        sut.value = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.state == .valid)
    }
    
    @Test("Given a view model, when validation fails, then `error` should be set with the validation error thrown")
    func validationFails() async throws {
        let sut = ValidatedFieldViewModel(title: "test_title",
                                          placeholder: "test_placeholder",
                                          instructions: "test_instructions",
                                          isSecure: true,
                                          validator: validator,
                                          scheduler: scheduler.eraseToAnyScheduler())
        
        let error = FakeLocalizedError.test
        validator.validationErrorResponse = error
        
        sut.value = "test_value"
        
        await scheduler.advance(by: .seconds(1))
        
        #expect(sut.state == .invalid(error))
    }
}
