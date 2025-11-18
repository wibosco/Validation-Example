//
//  EmailAddressValidationError.swift
//  Validation-Example
//
//  Created by William Boles on 20/10/2025.
//

import Foundation

enum EmailAddressValidationError: Error, Equatable {
    case empty
    case missingAtSign
    case multipleAtSigns
    case noLocalPart
    case noDomainPart
    case invalidLocalCharacters(Character)
    case localStartsOrEndsWithDot
    case consecutiveDots
    case invalidDomainLabel(String)
    case domainTooShort
    case invalidTopLevelDomain(String)
}

extension EmailAddressValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Email Address must not be empty."
        case .missingAtSign:
            return "Email Address must contain exactly one “@” symbol."
        case .multipleAtSigns:
            return "Email Address must not contain more than one “@”."
        case .noLocalPart:
            return "Email Address must include characters before the “@”."
        case .noDomainPart:
            return "Email Address must include characters after the “@”."
        case let .invalidLocalCharacters(ch):
            return "Email Address must not include invalid character “\(ch)” in the local part."
        case .localStartsOrEndsWithDot:
            return "Email Address local part must not start or end with a dot (“.”)."
        case .consecutiveDots:
            return "Email Address local part must not contain consecutive dots (“..”)."
        case let .invalidDomainLabel(label):
            return "Email Address domain label “\(label)” must only contain letters, numbers, or hyphens, and must not start or end with a hyphen."
        case .domainTooShort:
            return "Email Address must have at least two domain components separated by dots."
        case let .invalidTopLevelDomain(tld):
            return "Email Address top-level domain “.\(tld)” must be at least two letters."
        }
    }
}
