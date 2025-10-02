//
//  FakeLocalizedError.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 01/10/2025.
//

import Foundation

enum FakeLocalizedError: LocalizedError {
    case test
    
    var errorDescription: String? {
        switch self {
        case .test:
            return "Error description for `test` case"
        }
    }
}
