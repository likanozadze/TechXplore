//
//  MainViewModel.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//


import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var companies: [Business] = []
    @Published var isLoading = true
    @Published var error: Error?
    private let networkManager = NetworkManager.shared
    
    func fetchCompanies() {
        guard let businessURL = URL(string: "https://ideaxapp.azurewebsites.net/v1/Business") else {
            fatalError("Invalid URL")
        }
        
        networkManager.fetch(url: businessURL, responseType: [Business].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let businesses):
                DispatchQueue.main.async {
                    self.companies = businesses
                    self.isLoading = false
                    self.error = nil
                    self.fetchImagesForBusinesses()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    private func fetchImagesForBusinesses() {
        let baseUrl = "https://ideaxapp.azurewebsites.net/v1/Image/"
        for (index, business) in companies.enumerated() {
            let imageUrlString = business.image.url
            
            let fullImageUrlString = baseUrl + imageUrlString
            print("Original image URL string: \(imageUrlString)")
            print("Full image URL string: \(fullImageUrlString)")
            
            guard let encodedUrlString = fullImageUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let imageUrl = URL(string: encodedUrlString) else {
                print("Invalid or malformed URL for business: \(business.name)")
                continue
            }
            
            print("Encoded and valid URL: \(imageUrl)")
            
            networkManager.fetchImage(url: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.companies[index].businessImage = image
                    }
                    
                case .failure(let error):
                    print("Failed to fetch project image for \(business.name): \(error.localizedDescription)")
                }
            }
        }
    }
}
