//
//  StubValidator.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Foundation

@testable import Validation_Example

@MainActor
final class StubValidator<Value: Sendable & Equatable, ValidationError: Error>: Validator {    
    enum Event: Equatable {
        case validate(Value)
    }
    
    private(set) var events = [Event]()
    
    var validateResponse: Result<Void, ValidationError>?
    
    func validate(_ value: Value) throws(ValidationError) {
        events.append(.validate(value))
        
        try validateResponse?.get()
    }
}

