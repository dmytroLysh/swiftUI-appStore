//
//  ReviewResults.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 25.02.2025.
//

import Foundation

struct ReviewResults: Codable {
    let feed: ReviewFeed
}

struct ReviewFeed: Codable {
    let entry: [Review]
}

struct Review: Codable, Identifiable {
    var id: String { content.label }
    let content: JsonLabel
    let title: JsonLabel
    let author: Author
    let rating: JsonLabel
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case content
        case rating = "im:rating"
    }
}

struct JsonLabel: Codable {
    let label: String
}

struct Author: Codable {
    let name: JsonLabel
}
