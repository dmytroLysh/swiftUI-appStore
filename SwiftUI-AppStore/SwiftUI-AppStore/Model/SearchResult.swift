//
//  SearchResult.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 21.02.2025.
//

// trackName,trackId,artistName,primaryGenreName,screenshotUrls,artworkUrl512,averageUserRating,userRatingCount

struct SearchResults: Codable {
    let results: [AppResults]
}

struct AppResults: Codable, Identifiable {
    
    
    var id:Int  { trackId }
    
    let trackName: String
    let trackId: Int
    let artworkUrl512: String
    let primaryGenreName: String
    let screenshotUrls: [String]
    let artistName: String
    let averageUserRating: Double
    let userRatingCount: Int
}
