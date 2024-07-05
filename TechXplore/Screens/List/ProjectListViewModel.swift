//
//  ProjectListViewModel.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation
import SwiftUI

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []
    var companyName: String = ""
    private let networkManager = NetworkManager.shared
    
    init(companyID: Int) {
        fetchProjects(for: companyID)
    }
    
    private func fetchProjects(for companyID: Int) {
        guard let url = URL(string: "https://ideaxapp.azurewebsites.net/v1/Business/\(companyID)") else {
          
            return
        }
        
        networkManager.fetch(url: url, responseType: Business.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let business):
                DispatchQueue.main.async {
                    if let projects = business.projects {
                        self.projects = projects
                    }
                    self.companyName = business.name
                
                    self.fetchProjectImages()
                }
            case .failure(let error):
                print("Failed to fetch projects: \(error)")
              
            }
        }
    }
    
   
    
    private func fetchProjectImages() {
          for project in projects {
              if let firstImageURL = project.images.first?.url,
                 let encodedImageUrl = firstImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                 let imageUrl = URL(string: "https://ideaxapp.azurewebsites.net/v1/Image/\(encodedImageUrl)") {
                  
                  networkManager.fetchImage(url: imageUrl) { result in
                      switch result {
                      case .success(let image):
                          DispatchQueue.main.async {
                              if let index = self.projects.firstIndex(where: { $0.id == project.id }) {
                                  self.projects[index].projectImage = image
                              }
                          }
                      case .failure(let error):
                          print("Failed to fetch project image: \(error.localizedDescription)")
                      }
                  }
              } else {
                  print("No valid image URL found for project \(project.id).")
              }
          }
      }
  }
