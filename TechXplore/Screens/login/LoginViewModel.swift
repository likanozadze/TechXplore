//
//  LoginViewModel.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    public init() { }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void, navigationManager: NavigationManager) {
        isLoading = true
        
        let url = URL(string: "https://ideaxapp.azurewebsites.net/v1/User/Login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: loginData)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.error = error.localizedDescription
                    completion(false)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    self.error = "Failed to receive login response"
                    completion(false)
                    return
                }
                
                if 200..<300 ~= response.statusCode {
                    if let jwtToken = String(data: data, encoding: .utf8) {
                        TokenManager.shared.token = jwtToken
                        print("JWT Token: \(jwtToken)")
                        completion(true)
                        navigationManager.currentDestination = .mainView
                    } else {
                        self.error = "Failed to parse JWT token"
                        completion(false)
                    }
                } else {
                    self.error = "Invalid login credentials or server error"
                    completion(false)
                }
            }
        }
        task.resume()
    }
}

