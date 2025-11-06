//
//  DefaultValidationViewModelTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Testing

@testable import Validation_Example

// MARK: - Tests

struct DefaultValidationViewModelTests {
    var validator: StubValidator<FakeError>!

    // MARK: - Init

    init() {
        self.validator = StubValidator<FakeError>()
    }

    // MARK: - Tests

    @Test("Given `value` is set with a non-empty value, when validation passes, then `validationState` is `valid`")
    func valueIsNonEmptyAndValidationPasses() async throws {
        validator.validateResponse = .success(Void())

        let sut = DefaultValidationViewModel(
            defaultValue: "",
            validator: validator,
            errorMapper: { _ in return "test_mapped_value" },
        )

        let value = "test_value"
        sut.value = value
        
        _ = sut.validate("test_value")

        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .valid)
    }

    @Test("Given `value` is set with a non-empty value, when validation fails, then `validationState` is `invalid` and error is mapped")
    func valueIsNonEmptyAndValidationFails() async throws {
        let error = FakeError.test
        validator.validateResponse = .failure(error)

        var receivedError: FakeError?
        let mappedError = "test_mapped_value"
        let sut = DefaultValidationViewModel(
            defaultValue: "",
            validator: validator,
            errorMapper: { errorReturned in
                receivedError = errorReturned
                return mappedError
            },
        )

        let value = "test_value"
        sut.value = value
        
        _ = sut.validate("test_value")

        #expect(receivedError == error)
        #expect(validator.events[0] == .validate(value))
        #expect(sut.validationState == .invalid(mappedError))
    }

    @Test("Given `value` is set with an empty value, then `validationState` is `unchanged`")
    func valueIsEmpty() async throws {
        validator.validateResponse = .success(Void())

        let sut = DefaultValidationViewModel(
            defaultValue: "",
            validator: validator,
            errorMapper: { _ in return "test_mapped_value" }
        )

        sut.value = ""
        
        _ = sut.validate("")

        #expect(validator.events.isEmpty)
        #expect(sut.validationState == .unchanged)
    }
}
