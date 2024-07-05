//
//  File.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation
import SwiftUI

final class ProjectDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var projectImages: [String]
    @Published var selectedImageIndex = 0
    @Published var projectImage: UIImage?
    @Published var totalSharePercentage: Double = 0
    @Published var shares: [Share] = []
    
    // MARK: - Private Properties
    private var project: Project
    private let networkManager = NetworkManager.shared
    
    // MARK: - Initializer
    
    init(project: Project) {
        self.project = project
        self.projectImages = project.images.map { $0.url }
        fetchProjectImage()
        fetchUserShares()
    }
    
    // MARK: - Computed Properties
    var isAuthorized: Bool {
        return TokenManager.shared.token != nil
    }
    
    // MARK: - Methods
    private func fetchProjectImage() {
        guard let imageUrl = project.images.first?.url else {
            print("No image URL found for the project")
            return
        }
        
        guard let imageUrlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let imageUrl = URL(string: "https://ideaxapp.azurewebsites.net/v1/Image/\(imageUrlString)") else {
            print("Invalid image URL: \(imageUrl)")
            return
        }
        
        networkManager.fetchImage(url: imageUrl) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.projectImage = image
                }
            case .failure(let error):
                print("Failed to fetch project image: \(error.localizedDescription)")
            }
        }
    }
    
    internal func fetchUserShares() {
        guard isAuthorized else {
            return
        }
        
        let shareUrl = URL(string: "https://ideaxapp.azurewebsites.net/v1/Share/\(project.name)")!
        
        networkManager.fetch(url: shareUrl, responseType: ShareResponse.self) { result in
            switch result {
            case .success(let shareResponse):
                DispatchQueue.main.async {
                    self.totalSharePercentage = shareResponse.totalSharePercentage
                    self.shares = shareResponse.shares
                    print("Shares fetched successfully: \(self.shares)")
                }
            case .failure(let error):
                print("Failed to fetch user shares: \(error.localizedDescription)")
            }
        }
    }
    
    func invest(amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isAuthorized else {
            completion(.failure(NetworkManager.NetworkError.unknownError))
            return
        }
        
        let investUrl = URL(string: "https://ideaxapp.azurewebsites.net/v1/Project/Invest")!
        let requestData: [String: Any] = [
            "projectName": project.name,
            "amount": amount
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
            
            var request = URLRequest(url: investUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let jwtToken = TokenManager.shared.token {
                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            }
            request.httpBody = jsonData
            
            networkManager.fetch(url: investUrl, request: request) { result in
                switch result {
                case .success:
                    self.project.currentBudget += Int(amount)
                    completion(.success(()))
                case .failure(let error):
                   
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
