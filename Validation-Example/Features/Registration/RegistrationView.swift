//
//  RegistrationView.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @Bindable var viewModel1 = DefaultValidationViewModel(validator: PasswordValidator())
    @Bindable var viewModel2 = DefaultValidationViewModel(validator: PasswordValidator())
    @Bindable var viewModel3 = DefaultValidationViewModel(validator: PasswordValidator())
    
    // MARK: - Views
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            field("Scenario 1: No input", vm: viewModel1)
            field("Scenario 2: Valid input", vm: viewModel2)
            field("Scenario 3: Invalid input", vm: viewModel3)
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func field(_ scenario: String,
                       vm: DefaultValidationViewModel<PasswordValidator>) -> some View {
        @Bindable var vm = vm
        
        VStack(alignment: .leading, spacing: 30) {
            Text(scenario)
                .font(.custom("Marker Felt", size: 24))
            
            FormField(title: "Title",
                      placeholder: "Placeholder text",
                      value: $vm.value)
            .autocapitalization(.none)
            .isSecure()
            .validationState(vm.validationState)
        }
    }
}

#Preview {
    RegistrationView()
}
