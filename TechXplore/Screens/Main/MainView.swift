//
//  MainView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = MainViewModel()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            // MARK: - Error Handling
            if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                
                // MARK: - Header
                Text("Companies")
                    .font(.title)
                    .padding(.top)
                
                // MARK: - Company List Grid
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.companies) { company in
                        NavigationLink(destination: ProjectListView(viewModel: ProjectListViewModel(companyID: company.id))) {
                            ProjectComponentView(
                                projectName: company.name,
                                creationDate: company.creationDate,
                                business: company
                            )
                        }
                    }
                }
            }
        }
        
        .padding(.horizontal)
        
        // MARK: - Fetch Data on Appear
        .onAppear {
            viewModel.fetchCompanies()
        }
    }
}
