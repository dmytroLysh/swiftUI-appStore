//
//  SearchViewModel.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 21.02.2025.
//

import SwiftUI
import Combine

@Observable
class SearchViewModel {
    
    var results: [AppResults] = [AppResults]()
    var query = "Snapchat" {
        didSet {
            if oldValue != query {
                queryPublisher.send(query)
            }
        }
    }
    
    private var queryPublisher = PassthroughSubject<String,Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        queryPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                
                guard let self = self else { return }
                
                self.fetchJsonData(searchValue: newValue)
            }.store(in: &cancellables)
        
    }
    
    private func fetchJsonData(searchValue: String) {
        Task {
            do {
                self.results = try await APIService.fetchSearchResults(searchValue: searchValue)
                
            } catch {
                print("Failed to due error", error)
            }
        }
    }
    
}
