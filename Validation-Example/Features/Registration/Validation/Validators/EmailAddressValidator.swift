//
//  EmailAddressValidator.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation

struct EmailAddressValidator: Validator {

    // MARK: - Validator
    
    func validate(_ value: String) async throws(EmailAddressValidationError) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        // 1. Empty
        guard !trimmed.isEmpty else {
            throw .empty
        }

        // 2. Split on “@”
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count > 1 else {
            throw .missingAtSign
        }
        
        guard parts.count == 2 else {
            throw .multipleAtSigns
        }

        let local = String(parts[0])
        let domain = String(parts[1])

        // 3. Local / Domain presence
        guard !local.isEmpty else {
            throw .noLocalPart
        }
        
        guard !domain.isEmpty else {
            throw .noDomainPart
        }

        // 4. Local part rules
        let localAllowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "._%+-"))
        
        for c in local {
            if String(c).rangeOfCharacter(from: localAllowed.inverted) != nil {
                throw .invalidLocalCharacters(c)
            }
        }
        
        if local.first == "." || local.last == "." {
            throw .localStartsOrEndsWithDot
        }
        
        if local.contains("..") {
            throw .consecutiveDots
        }

        // 5. Domain part rules
        let labels = domain.split(separator: ".").map(String.init)
        
        guard labels.count >= 2 else {
            throw .domainTooShort
        }

        let labelAllowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        for label in labels {
            if label.rangeOfCharacter(from: labelAllowed.inverted) != nil ||
               label.first == "-" ||
               label.last == "-" {
                throw .invalidDomainLabel(label)
            }
        }

        // 6. Top-level domain
        let tld = labels.last!
        let letters = CharacterSet.letters
        
        if tld.count < 2 ||
           tld.rangeOfCharacter(from: letters.inverted) != nil {
            throw .invalidTopLevelDomain(tld)
        }
    }
}
