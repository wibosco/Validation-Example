//
//  StubValidator.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Foundation

@testable import Validation_Example

final class StubValidator<ValidationError: Error>: Validator {
    enum Event: Equatable {
        case validate(String)
    }
    
    private(set) var events = [Event]()
    
    var validateResponse: Result<Void, ValidationError>?
    
    func validate(_ value: String) throws(ValidationError) {
        events.append(.validate(value))
        
        try validateResponse?.get()
    }
}
