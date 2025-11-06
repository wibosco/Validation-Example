//
//  StubValidationViewModel.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 16/10/2025.
//

import Foundation

@testable import Validation_Example

final class StubValidationViewModel: ValidationViewModel {
    enum Event: Equatable {
        case validate(String)
    }
    
    private(set) var events = [Event]()
    
    var value: String = ""
    var validationState: ValidatedState = .unchanged
    
    func validate(_ currentValue: String) -> ValidatedState {
        events.append(.validate(currentValue))
        
        return validationState
    }
}
