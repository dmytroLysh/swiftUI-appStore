//
//  APIService.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 25.02.2025.
//

import Foundation

struct APIService {
    
    enum APIError: Error {
        case appDetailNotFound
        case badResponse(statusCode: Int)
    }
    
    static func fetchAppDetail(trackID: Int) async throws -> AppDetail {
        
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(trackID)")!
        
        let(data, response) =  try await URLSession.shared.data(from: url)
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200..<299 ~= statusCode) {
            throw APIError.badResponse(statusCode: statusCode)
        }
        
        let appDetailResults = try JSONDecoder().decode(AppDetailResults.self, from: data)
        
        if let appDetail = appDetailResults.results.first {
            return appDetail
        }
        
        
        throw APIError.appDetailNotFound
    }
    
}
