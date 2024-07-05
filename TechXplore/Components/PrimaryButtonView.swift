//
//  PrimaryButtonView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//


import SwiftUI

struct PrimaryButtonView: View {
    //MARK: - Properties
    var text: String
    var textColor: Color
    var backgroundColor: Color
    
    //MARK: - Body
    var body: some View {
        Text(text.capitalized)
            .foregroundStyle(textColor)
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundColor)
            .cornerRadius(6)
            .padding(.horizontal, 16)
    }
}
