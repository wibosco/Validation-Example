//
//  ValidatedField.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import SwiftUI

struct ValidatedField: View {
    @ObservedObject var viewModel: ValidatedFieldViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 6) {
            Text(viewModel.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Group {
                if viewModel.isSecure {
                    SecureField(viewModel.placeholder,
                                text: $viewModel.value)
                } else {
                    TextField(viewModel.placeholder,
                              text: $viewModel.value)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.showError ? Color.red : Color.clear, lineWidth: 2)
            )
            .onSubmit {
                viewModel.validate()
            }
            
            if viewModel.showError, let error = viewModel.validationResult.errorMessage {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(error)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .transition(.opacity)
            }
            
            if let instructions = viewModel.instructions {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                    
                    Text(instructions)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showError)
    }
}
