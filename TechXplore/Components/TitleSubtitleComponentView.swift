//
//  TitleSubtitleComponentView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct TitleSubtitleComponentView: View {
    
    var title: String
    var titleFont: CGFloat
    var alignmentAxe: HorizontalAlignment
    var titleWeight: Font.Weight
    var subTitleWeight: Font.Weight
    
    var body: some View {
        VStack(alignment: alignmentAxe) {
            Text(title)
                .font(.system(size: titleFont, weight: titleWeight))
                .foregroundColor(Color("componentColor"))
        }
    }
}

#Preview {
    TitleSubtitleComponentView(title: "Test",titleFont: 15, alignmentAxe: .leading, titleWeight: .bold, subTitleWeight: .light)
}
