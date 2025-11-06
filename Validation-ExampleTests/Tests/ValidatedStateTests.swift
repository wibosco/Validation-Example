//
//  ValidatedStateTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 13/10/2025.
//

import Testing

@testable import Validation_Example

struct ValidatedStateTests {

    @Test("Given state, when `isInvalid` is called, then the correct boolean is returned",
          arguments: zip(
            [
                .unchanged,
                .invalid("test_value"),
                .valid
            ] as [ValidatedState],
            [
                false,
                false,
                true
            ]
          )
    )
    func isValid(state: ValidatedState,
                 outcome: Bool) async throws {
        #expect(state.isValid == outcome)
    }
    
    @Test("Given state, when `isValid` is called, then the correct boolean is returned",
          arguments: zip(
            [
                .unchanged,
                .invalid("test_value"),
                .valid
            ] as [ValidatedState],
            [
                false,
                true,
                false
            ]
          )
    )
    func isInvalid(state: ValidatedState,
                   outcome: Bool) async throws {
        #expect(state.isInvalid == outcome)
    }
}
