//
//  ReviewsViewModel.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 25.02.2025.
//

import SwiftUI

@Observable
class ReviewsViewModel {
    
    private let trackId: Int
    var entries = [Review]()
    
    init(trackId: Int) {
        
        self.trackId = trackId
        fetchReviews()
    }
    
    private func fetchReviews() {
        Task {
            do {

                self.entries = try await APIService.fetchReviews(trackId: trackId)
                
            } catch {
                print("Failed fethc app detail", error)
            }
        }
    }
    
}
