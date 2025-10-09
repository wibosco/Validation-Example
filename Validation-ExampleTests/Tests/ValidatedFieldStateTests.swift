//
//  ValidatedFieldStateTests.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 08/10/2025.
//

import Testing

@testable import Validation_Example

struct ValidatedFieldStateTests {

    // MARK: - Tests
    
    @Test("Given a valid case, when `isValid` is called, the true is returned")
    func isValidWithValidCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.valid
        
        #expect(state.isValid == true)
    }
    
    @Test("Given an invalid case, when `isValid` is called, the false is returned")
    func isValidWithinvalidCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.invalid(.test)
        
        #expect(state.isValid == false)
    }
    
    @Test("Given a empty case, when `isValid` is called, the false is returned")
    func isValidWithEmptyCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.empty
        
        #expect(state.isValid == false)
    }
    
    @Test("Given a valid case, when `isInvalid` is called, the false is returned")
    func isInvalidWithValidCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.valid
        
        #expect(state.isInvalid == false)
    }
    
    @Test("Given an invalid case, when `isInvalid` is called, the true is returned")
    func isInvalidWithinvalidCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.invalid(.test)
        
        #expect(state.isInvalid == true)
    }
    
    @Test("Given a empty case, when `isInvalid` is called, the false is returned")
    func isInvalidWithEmptyCase() async throws {
        let state = ValidatedFieldViewModel<StubValidator<FakeLocalizedError>>.ValidatedFieldState.empty
        
        #expect(state.isInvalid == false)
    }
}
