//
//  DefaultValidationViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Testing

@testable import Validation_Example

@MainActor
struct DefaultValidationViewModelTests {
    var validator: StubValidator<FakeError>!
    var debouncer: StubDebouncer!
    
    // MARK: - Init
    
    init() {
        self.debouncer = StubDebouncer()
        self.validator = StubValidator<FakeError>()
    }
    
    // MARK: - Tests
    
    @Test("Given `value` is set with a non-empty value, when validation passes, then `validationState` is `valid`")
    func valueIsNonEmptyAndValidationPasses() async throws {
        validator.validateResponse = .success(Void())
        
        let sut = DefaultValidationViewModel(validator: validator,
                                             errorMapper: { _ in return "test_mapped_value" },
                                             debouncer: debouncer)
        
        let value = "test_value"
        sut.value = value
        
        await debouncer.waitForSubmit()
        
        guard case let .submit(action) = await debouncer.events[0] else {
            Issue.record("Unexpected event")
            return
        }
        
        await action()
        
        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .valid)
    }
    
    @Test("Given `value` is set with a non-empty value, when validation passes, then `validationState` is `valid`")
    func valueIsNonEmptyAndValidationFails() async throws {
        let error = FakeError.test
        validator.validateResponse = .failure(error)
        
        var receivedError: FakeError?
        let mappedError = "test_mapped_value"
        let sut = DefaultValidationViewModel(validator: validator,
                                             errorMapper: { errorReturned in
            receivedError = errorReturned
            return mappedError
        },
                                             debouncer: debouncer)
        
        let value = "test_value"
        sut.value = value
        
        await debouncer.waitForSubmit()
        
        guard case let .submit(action) = await debouncer.events[0] else {
            Issue.record("Unexpected event")
            return
        }
        
        await action()
        
        #expect(receivedError == error)
        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .invalid(mappedError))
    }
    
    @Test("Given `value` is set with an empty value, then `validationState` is `empty`")
    func valueIsEmpty() async throws {
        validator.validateResponse = .success(Void())
        
        let sut = DefaultValidationViewModel(validator: validator,
                                             errorMapper: { _ in return "test_mapped_value" },
                                             debouncer: debouncer)
        
        sut.value = ""
        
        await debouncer.waitForSubmit()
        
        guard case let .submit(action) = await debouncer.events[0] else {
            Issue.record("Unexpected event")
            return
        }
        
        await action()
        
        #expect(validator.events.isEmpty)
        #expect(sut.validationState == .empty)
    }
}
