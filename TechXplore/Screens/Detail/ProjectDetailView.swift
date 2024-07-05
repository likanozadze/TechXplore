//
//  ProjectDetailView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI
import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    @ObservedObject var viewModel: ProjectDetailViewModel
    @State private var investAmount: String = ""
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: - Project Image
                if let image = viewModel.projectImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // MARK: - Image Carousel
                ImageCarouselComponentView(images: viewModel.projectImages)
                
                // MARK: - Project Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Project description")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                    Text(project.description)
                        .font(.system(size: 16))
                        .lineLimit(isExpanded ? nil : 4)
                        .padding(.bottom, 10)
                    
                    if shouldShowMoreButton(for: project.description) {
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Text(isExpanded ? "Less" : "More")
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                
                // MARK: - Project Financial Information
                VStack {
                    HStack {
                        Text("Required Budget")
                            .foregroundColor(.gray)
                        Text("\(project.requiredBudget)")
                            .foregroundColor(.gray)
                        Divider().padding(.vertical, 10)
                            .bold()
                        Text("Current: \(project.currentBudget)")
                            .foregroundColor(.green)
                    }
                    Divider().padding(.vertical, 10)
                        .bold()
                    Text("Your Share: \(viewModel.totalSharePercentage)%")
                        .foregroundColor(.blue)
                    
                    // MARK: - Investment Section
                    if TokenManager.shared.token != nil {
                        if viewModel.isAuthorized {
                            TextField("Enter amount", text: $investAmount)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                guard let amount = Double(self.investAmount) else {
                                    print("Invalid amount")
                                    return
                                }
                                
                                viewModel.invest(amount: amount) { result in
                                    switch result {
                                    case .success:
                                        print("Investment successful")
                                    case .failure(let error):
                                        print("Investment failed: \(error.localizedDescription)")
                                    }
                                }
                            }) {
                                Text("Invest")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            Text("Please login to invest in this project.")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle(project.name)
        }
        .onAppear {
            viewModel.fetchUserShares()
        }
    }
    
    // MARK: - Helper Functions
    private func shouldShowMoreButton(for text: String) -> Bool {
        let lines = text.components(separatedBy: "\n")
        return lines.count > 4
    }
}
