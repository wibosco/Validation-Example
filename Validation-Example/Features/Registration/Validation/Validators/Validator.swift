//
//  Validator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation

protocol Validator: Sendable {
    associatedtype Value: Sendable & Equatable
    associatedtype ValidationError: Error
    
    func validate(_ value: Value) async throws(ValidationError)
}
