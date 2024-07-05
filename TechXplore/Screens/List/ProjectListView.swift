//
//  ProjectListView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

// MARK: - Properties

struct ProjectListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProjectListViewModel
    
    var body: some View {
        List(viewModel.projects) { project in
            NavigationLink(destination: ProjectDetailView(project: project,
                                                          viewModel: ProjectDetailViewModel(project: project)))
            {
                ProjectRowView(project: project)
            }
        }
        .navigationTitle(viewModel.companyName)
    }
}


struct ProjectRowView: View {
    let project: Project
    
    @State private var projectImage: UIImage?
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                if let image = project.projectImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(project.name)
                    .font(.headline)
                Text(project.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    VStack {
                        Text("Required")
                            .font(.caption)
                        Text("\(project.requiredBudget)")
                            .foregroundColor(.gray)
                    }
                    Divider().padding(.vertical, 4)
                    
                    VStack {
                        Text("Accumulated")
                            .font(.caption)
                        Text("\(project.currentBudget)")
                            .foregroundColor(.green)
                    }
                }
                
            }
        }
    }
}

