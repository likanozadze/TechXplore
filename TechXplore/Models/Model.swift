//
//  Model.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation
import SwiftUI

struct User: Codable {
    var personalNumber: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: String
    var password: String
}

struct Business: Identifiable, Decodable {
    let id: Int
    let name: String
    let creationDate: Date
    let image: ImageURL
    let projects: [Project]?
    var businessImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id, name, creationDate, image, projects
    }
}
struct Project: Identifiable, Decodable {
    let id = UUID()
    var name: String
    var creationDate: String?
    var description: String
    var startDate: Date
    var endDate: Date
    var requiredBudget: Int
    var currentBudget: Int
    var businessId: Int
    var images: [ImageURL]
    var projectImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case name
        case creationDate
        case description
        case startDate
        case endDate
        case requiredBudget
        case currentBudget
        case businessId
        case images
    }
}
    
    struct ImageURL: Decodable {
        var url: String
    }
    
    struct Share: Codable {
        let id: Int
        let sharePercentage: Double
    }
    
    struct ShareResponse: Codable {
        let totalSharePercentage: Double
        let shares: [Share]
    }

    struct CreditCard {
        var name: String
        var number: String
    }

