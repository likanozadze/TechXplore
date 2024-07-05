//
//  PasswordView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct PasswordView: View {
    
    // MARK: - Properties
    let condition: Bool
    let text: String
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: condition ? "checkmark.circle.fill" : "circle")
                .foregroundColor(condition ? .green : .gray)
            Text(text)
                .foregroundColor(.gray)
                .font(.system(size: 10))
        }
    }
}

// MARK: - Preview
#Preview {
    PasswordView(condition: false, text: "Test")
}

