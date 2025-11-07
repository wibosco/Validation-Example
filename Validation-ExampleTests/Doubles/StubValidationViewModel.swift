//
//  StubValidationViewModel.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 16/10/2025.
//

import Foundation

@testable import Validation_Example

@MainActor
final class StubValidationViewModel: ValidationViewModel {
    var value: String = ""
    var validationState: ValidatedState = .unchanged
}
