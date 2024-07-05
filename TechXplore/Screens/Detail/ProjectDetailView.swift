//
//  ProjectDetailView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    @ObservedObject var viewModel: ProjectDetailViewModel
    @State private var investAmount: String = ""
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let image = viewModel.projectImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                ImageCarouselComponentView(images: viewModel.projectImages)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(project.description)
                        .font(.system(size: 16))
                    Text("Required Budget: \(project.requiredBudget)")
                        .foregroundColor(.gray)
                    Text("Current Budget: \(project.currentBudget)")
                        .foregroundColor(.green)
              
                    
                    if viewModel.shares.isEmpty {
                                        Text("No shares available")
                                            .foregroundColor(.gray)
                                            .padding(.top, 10)
                                    } else {
                                        Text("Your Share: \(viewModel.totalSharePercentage)%")
                                            .foregroundColor(.blue)
                                            .padding(.top, 10)
                                    
                                    }
                    
                    if TokenManager.shared.token != nil {
                        if viewModel.isAuthorized {
                            TextField("Enter amount to invest", text: $investAmount)
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
                            .padding()
                        } else {
                            Text("Please login to invest in this project.")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                .navigationTitle(project.name)
            }
            .onAppear {
                viewModel.fetchUserShares() // Ensure shares are fetched when view appears
            }
        }
    }
}
