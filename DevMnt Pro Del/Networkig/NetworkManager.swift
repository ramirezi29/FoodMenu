//
//  NetworkManager.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/5/22.
//

import UIKit

class NetworkManager {
    
    //goal: badBaseURL "https://api.yelp.com/v3/businesses/search"
    let baseURL = URL(string: "https://api.yelp.com/v3")
    static let shared = NetworkManager()
    func newFetchBusiness() async throws -> YelpData {
        
        guard var url = baseURL else {
            throw NetworkError.badBaseURL
        }
        
        url.appendPathComponent("businesses")
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "term", value: "pizza"),
            URLQueryItem(name: "location", value: "1550 Digital Dr #400, Lehi, UT 84043"),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        guard let builtURL = components?.url else {
            throw NetworkError.badBuiltURL
        }
        var request = URLRequest(url: builtURL)
        
        request.allHTTPHeaderFields = Constants.headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let yelpData =  try JSONDecoder().decode(YelpData.self, from: data)
        
        return yelpData
        
    }
    
    func fetchBusiness(type: String,completion: @escaping (Result<YelpData, NetworkError>) -> Void ) {
        
        guard var url = baseURL else {
            completion(.failure(NetworkError.badBaseURL))
            return
        }
        
        url.appendPathComponent("businesses")
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "term", value: type),
            URLQueryItem(name: "location", value: "1550 Digital Dr #400, Lehi, UT 84043"),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        guard let builtURL = components?.url else {
            
            completion(.failure(.badBuiltURL))
            return
        }
        
        var request = URLRequest(url: builtURL)
        
        request.allHTTPHeaderFields = Constants.headers
        
        
        print("[NetworkManager] - \(#function) builtURL: \(builtURL.description)")
        
        //MARK: - URL Session Data Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.invalidData(error.localizedDescription)))
                print("error: \(error): \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData(response.debugDescription)))
                return
            }
            
            guard let data = data else {
                print("error: \(String(describing: error)): \(error?.localizedDescription ?? "")")
                completion(.failure(.invalidData("Invalid Data")))
                return
            }
            
            do {
                let business = try JSONDecoder().decode(YelpData.self, from: data)
                completion(.success(business))
                return
            } catch {
                print("error: \(error): \(error.localizedDescription)")
                completion(.failure(.invalidData(error.localizedDescription)))
                return
            }
        }.resume()
    }
}

