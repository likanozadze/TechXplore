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
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
//            if viewModel.isLoading {
//                ProgressView("Loading...")
//                    .padding()
      if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Construction companies")
                    .font(.title)
                    .padding(.top)
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.companies) { company in
                        NavigationLink(destination: ProjectListView(viewModel: ProjectListViewModel(companyID: company.id))) {
                            ProjectComponentView(
                                projectName: company.name,
                                creationDate: company.creationDate, business: company
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.fetchCompanies()
        }
    }
}
