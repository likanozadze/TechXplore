//
//  TokenManager.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation


final class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "jwtToken"
    
    private init() { }
    
    var token: String? {
        get {
             UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
}
