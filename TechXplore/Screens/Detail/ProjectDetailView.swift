//
//  ProjectDetailView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//


import SwiftUI
import Lottie

struct ProjectDetailView: View {
    let project: Project
    
    @ObservedObject var viewModel: ProjectDetailViewModel
    @State private var investAmount: String = ""
    @State private var isExpanded: Bool = false
    @State private var isInvesting = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                imageView
                ImageCarouselComponentView(images: viewModel.projectImages)
                textView
                budgetView
                Spacer()
            }
            .padding()
        }
        .navigationTitle(project.name)
        .onAppear {
            viewModel.fetchUserShares()
        }
    }
    
    // MARK: - Project Image
    
    private var imageView: some View {
        Group {
            if let image = viewModel.projectImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50)
                
            }
        }
    }
    
    // MARK: - Project Description
    private var textView: some View {
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
    }
    
    // MARK: - Project Financial Information
    
    private var budgetView: some View {
        VStack {
            HStack {
                Text("Required Budget")
                    .foregroundColor(.gray)
                Spacer()
                Text("\(project.requiredBudget)")
                    .foregroundColor(.gray)
            }
            ProgressView(value: Double(project.currentBudget), total: Double(project.requiredBudget))
                .progressViewStyle(LinearProgressViewStyle())
                .foregroundColor(.green)
                .padding(.vertical, 8)
            
            HStack {
                Text("Current Budget")
                    .foregroundColor(.gray)
                Spacer()
                Text("\(project.currentBudget)")
                    .foregroundColor(.green)
            }
            
            ProgressView(value: Double(project.currentBudget), total: Double(project.requiredBudget))
                .progressViewStyle(LinearProgressViewStyle())
                .foregroundColor(.green)
                .padding(.vertical, 8)
            
            Divider().padding(.vertical, 10)
                .bold()
            
            // MARK: - Investment Section
            if TokenManager.shared.token != nil {
                if viewModel.isAuthorized {
                    Group {
                        if isInvesting {
                            LottieView(filename: "Animation - 1720201013725")
                                .frame(width: 100, height: 100)
                                .padding()
                        } else {
                            HStack {
                                TextField("Enter amount", text: $investAmount)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.darkgray)
                                
                                Text("Your Share: \(String(format: "%.2f", viewModel.totalSharePercentage))%")
                                    .foregroundColor(.darkgray)
                            }
                            Button(action: {
                                guard let amount = Double(self.investAmount) else {
                                    print("Invalid amount")
                                    return
                                }
                                
                                self.isInvesting = true
                                
                                viewModel.invest(amount: amount) { result in
                                    self.isInvesting = false
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
                        }
                    }
                } else {
                    Text("Please login to invest in this project.")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    private func shouldShowMoreButton(for text: String) -> Bool {
        let lines = text.components(separatedBy: "\n")
        return lines.count > 4
    }
}
