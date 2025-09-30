//
//  Validator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation

protocol Validator {
    associatedtype ValidationError: LocalizedError
    func validate(_ value: String) throws(ValidationError)
}
