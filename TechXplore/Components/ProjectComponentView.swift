//
//  ProjectComponentView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct ProjectComponentView: View {
    
    // MARK: - Components

    var projectName: String
    var creationDate: Date
    var business: Business
    @State private var businessImage: UIImage?
    
    
    private var formattedCreationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: creationDate)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            travelImageView
            titleSubtitleView
            creationDateLabel
        }
        
        .padding(10)
        .background(.font)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .lineLimit(1)
        .truncationMode(.tail)
        .frame(width: 140, height: 180)
    }
    
    // MARK: - ImageView

    private var travelImageView: some View {
        VStack {
           
            if let businessImage = business.businessImage {
                Image(uiImage: businessImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
            } else {
                        Image("building")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
   
    private var titleSubtitleView: some View {
        TitleSubtitleComponentView(
            title: projectName,
            titleFont: 12,
            alignmentAxe: .leading,
            titleWeight: .semibold,
            subTitleWeight: .light
        )
        .lineLimit(1)
        .truncationMode(.tail)
    }
    
    // MARK: - Creation Date Label
    private var creationDateLabel: some View {
        Text("Created on: \(formattedCreationDate)")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.gray)
            .lineLimit(1)
                   .truncationMode(.tail)
    }
}

//#Preview {
//    ProjectComponentView(imageName: "building", projectName: "არქი", creationDate: Date())
//}
