//
//  RegistrationView.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    @State private var showSubmissionAlert = false
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ValidatedField(viewModel: viewModel.emailAddressViewModel)
                ValidatedField(viewModel: viewModel.passwordViewModel)
                
                Spacer()
                
                Button("Submit") {
                    showSubmissionAlert = true
                }
                .disabled(!viewModel.canSubmit)
            }
            .padding()
            .navigationTitle("Registration")
            .alert("Account", isPresented: $showSubmissionAlert) {
                Button("OK") { }
            } message: {
                Text("Congratulations you managed to pass validation!")
            }
        }
    }
}

#Preview {
    let viewModel = RegistrationViewModel()
    RegistrationView(viewModel: viewModel)
}
