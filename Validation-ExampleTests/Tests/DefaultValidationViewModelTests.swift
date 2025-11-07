//
//  DefaultValidationViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Testing

@testable import Validation_Example

struct DefaultValidationViewModelTests {
    var validator: StubValidator<String, FakeError>!
    var debouncer: StubDebouncer!
    
    // MARK: - Init
    
    init() {
        self.debouncer = StubDebouncer()
        self.validator = StubValidator<String, FakeError>()
    }
    
    // MARK: - Tests
    
    @Test("Given `value` is set with a non-empty value, when validation passes, then `validationState` is `valid`")
    func valueIsNonEmptyAndValidationPasses() async throws {
        validator.validateResponse = .success(Void())
        
        let sut = DefaultValidationViewModel(defaultValue: "",
                                             validator: validator,
                                             errorMapper: { _ in return "test_mapped_value" },
                                             debouncer: debouncer)
        
        let value = "test_value"
        sut.value = value
        
        guard case let .submit(action) = debouncer.events[0] else {
            Issue.record("Unexpected event")
            return
        }
        
        await action()
        
        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .valid)
    }
    
    @Test("Given `value` is set with a non-empty value, when validation fails, then `validationState` is `invalid` and error is mapped")
    func valueIsNonEmptyAndValidationFails() async throws {
        let error = FakeError.test
        validator.validateResponse = .failure(error)
        
        var receivedError: FakeError?
        let mappedError = "test_mapped_value"
        let sut = DefaultValidationViewModel(defaultValue: "",
                                             validator: validator,
                                             errorMapper: { errorReturned in
            receivedError = errorReturned
            return mappedError
        },
                                             debouncer: debouncer)
        
        let value = "test_value"
        sut.value = value
        
        guard case let .submit(action) = debouncer.events[0] else {
            Issue.record("Unexpected event")
            return
        }
        
        await action()
        
        #expect(receivedError == error)
        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .invalid(mappedError))
    }
    
    @Test("Given `value` is set with the same value as the `defaultValue`, then `validationState` is `unchanged`")
    func valueIsEmpty() async throws {
        validator.validateResponse = .success(Void())
        
        let defaultValue = "test_value"
        
        let sut = DefaultValidationViewModel(defaultValue: defaultValue,
                                             validator: validator,
                                             errorMapper: { _ in return "test_mapped_value" },
                                             debouncer: debouncer)
        
        sut.value = defaultValue
        
        #expect(await validator.events.isEmpty)
        #expect(sut.validationState == .unchanged)
    }
}
