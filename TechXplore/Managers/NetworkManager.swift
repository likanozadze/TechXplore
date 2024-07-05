//
//  NetworkManager.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation
import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    enum NetworkError: Error {
        case noData
        case notFound
        case internalServerError
        case unknownError
    }
    
    func fetch<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let jwtToken = TokenManager.shared.token {
                      request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                  }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.unknownError))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    guard let data = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                        let decodedResponse = try decoder.decode(responseType, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                case 404:
                    completion(.failure(NetworkError.notFound))
                case 500:
                    completion(.failure(NetworkError.internalServerError))
                default:
                    completion(.failure(NetworkError.unknownError))
                }
            }
        }.resume()
    }
    
    func fetch(url: URL, request: URLRequest, completion: @escaping (Result<Void, Error>) -> Void) {
            let session = URLSession.shared
            session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(NetworkError.unknownError))
                        return
                    }
                    
                    switch httpResponse.statusCode {
                    case 200:
                        completion(.success(()))
                    case 404:
                        completion(.failure(NetworkError.notFound))
                    case 500:
                        completion(.failure(NetworkError.internalServerError))
                    default:
                        completion(.failure(NetworkError.unknownError))
                    }
                }
            }.resume()
        }
        
    func fetchImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let unknownError = NetworkError.unknownError
                    print("Failed to fetch image: No HTTP response")
                    completion(.failure(unknownError))
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    let statusCodeError = NetworkError.unknownError
                    print("Failed to fetch image: HTTP status code \(httpResponse.statusCode)")
                    completion(.failure(statusCodeError))
                    return
                }
                
                guard let data = data else {
                    let noDataError = NetworkError.noData
                    print("Failed to fetch image: No data received")
                    completion(.failure(noDataError))
                    return
                }
                
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    let unknownError = NetworkError.unknownError
                    print("Failed to fetch image: Invalid image data")
                    completion(.failure(unknownError))
                }
            }
        }.resume()
    }
}
extension DateFormatter {
    static var customFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}
