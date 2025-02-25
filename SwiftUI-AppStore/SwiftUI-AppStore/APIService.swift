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
        case badURL
        case badResponse(statusCode: Int)
    }
    
    static func fetchAppDetail(trackID: Int) async throws -> AppDetail {
        
        let appDetail: AppDetailResults = try await decode(urlString: "https://itunes.apple.com/lookup?id=\(trackID)")
        
        if let appDetail = appDetail.results.first {
                    return appDetail
                }
        throw APIError.appDetailNotFound
    }
    
    static func fetchSearchResults(searchValue: String) async throws -> [AppResults] {
        
        let searchResult: SearchResults = try await decode(urlString:  "https://itunes.apple.com/search?term=\(searchValue)&entity=software")
        return searchResult.results
    }
    
    static func fetchReviews(trackId: Int) async throws -> [Review] {
        
        let reviews: ReviewResults = try await decode(urlString: "https://itunes.apple.com/rss/customerreviews/page=1/id=\(trackId)/sortby=mostrecent/json?l=en&cc=us")
        return reviews.feed.entry
    }
    
    static private func decode<T:Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200..<299 ~= statusCode) {
            throw APIError.badResponse(statusCode: statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
        
    }
    
}
