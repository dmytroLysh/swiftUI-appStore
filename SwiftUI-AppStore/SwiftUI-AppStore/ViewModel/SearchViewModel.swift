//
//  SearchViewModel.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 21.02.2025.
//

import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var results: [AppResults] = [AppResults]()
    @Published var query = "Snapchat"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                
                guard let self = self else { return }
                
                self.fetchJsonData(searchValue: newValue)
            }.store(in: &cancellables)
        
    }
    
    private func fetchJsonData(searchValue: String) {
        Task {
            do {
                guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchValue)&entity=software") else { return }
                let (data,_) = try await URLSession.shared.data(from: url)
                
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                self.results = searchResult.results
                
                
            } catch {
                print("Failed to due error", error)
            }
        }
    }
    
}
