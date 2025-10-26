//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation

@Observable
final class RegistrationViewModel {
    var canSubmit: Bool {
        emailAddressViewModel.validationState.isValid &&
        passwordViewModel.validationState.isValid
    }
    
    var emailAddressViewModel: AnyValidationViewModel<String>
    var passwordViewModel: AnyValidationViewModel<String>
    
    // MARK: - Init
    
    init(emailAddressViewModel: AnyValidationViewModel<String>,
         passwordViewModel: AnyValidationViewModel<String>) {
        self.emailAddressViewModel = emailAddressViewModel
        self.passwordViewModel = passwordViewModel
    }
}
