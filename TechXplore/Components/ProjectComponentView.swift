//
//  ProjectComponentView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct ProjectComponentView: View {
    
    // MARK: - Properties
    
    var projectName: String
    var creationDate: Date
    var business: Business
    @State private var businessImage: UIImage?
    @State private var isLoadingImage = true 
    
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
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .lineLimit(1)
        .truncationMode(.tail)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoadingImage = false
            }
        }
    }
    
    // MARK: - ImageView
    
    private var travelImageView: some View {
        Group {
            if isLoadingImage {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .cornerRadius(10)
                    .frame(height: 100)
            } else if let businessImage = business.businessImage {
                Image(uiImage: businessImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .cornerRadius(10)
            } else {
                Image("building")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .cornerRadius(10)
            }
        }
    }
    
    private var titleSubtitleView: some View {
        TitleSubtitleComponentView(
            title: projectName,
            titleFont: 14,
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
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.gray)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

//#Preview {
//    ProjectComponentView(projectName: "არქი", creationDate: Date(), business: Business())
//}
