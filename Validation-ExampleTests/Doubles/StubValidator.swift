//
//  StubValidator.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Foundation

@testable import Validation_Example

actor StubValidator<ValidationError: Error>: Validator {
    enum Event: Equatable {
        case validate(String)
    }
    
    private(set) var events = [Event]()
    
    private var validateResponse: Result<Void, ValidationError>?
    
    func setValidateResponse(_ response: Result<Void, ValidationError>) {
        validateResponse = response
    }
    
    func validate(_ value: String) async throws(ValidationError) {
        events.append(.validate(value))
        
        try validateResponse?.get()
    }
}
