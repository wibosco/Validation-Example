//
//  ValidationStateTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 13/10/2025.
//

import Testing

@testable import Validation_Example

struct ValidationStateTests {
    
    // MARK: - Tests
    
    @Test("Given state, when `isInvalid` is called, then the correct boolean is returned",
          arguments: zip(
            [
                .unchanged,
                .invalid("test_value"),
                .valid
            ] as [ValidationState],
            [
                false,
                false,
                true
            ]
          )
    )
    func isValid(state: ValidationState,
                 outcome: Bool) async throws {
        #expect(state.isValid == outcome)
    }
    
    @Test("Given state, when `isValid` is called, then the correct boolean is returned",
          arguments: zip(
            [
                .unchanged,
                .invalid("test_value"),
                .valid
            ] as [ValidationState],
            [
                false,
                true,
                false
            ]
          )
    )
    func isInvalid(state: ValidationState,
                   outcome: Bool) async throws {
        #expect(state.isInvalid == outcome)
    }
}
