//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation

@Observable
@MainActor
final class RegistrationViewModel {
    var canSubmit: Bool {
        emailAddressViewModel.validationState.isValid &&
        passwordViewModel.validationState.isValid
    }
    
    var emailAddressViewModel: any ValidationViewModel
    var passwordViewModel: any ValidationViewModel
    
    // MARK: - Init
    
    init(emailAddressViewModel: any ValidationViewModel,
         passwordViewModel: any ValidationViewModel) {
        self.emailAddressViewModel = emailAddressViewModel
        self.passwordViewModel = passwordViewModel
    }
}
