//
//  ContentView.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 11.12.2024.
//

import SwiftUI

// trackName,trackId,artistName,primaryGenreName,screenshotUrls,artworkUrl512

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
}

import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var results: [AppResults] = [AppResults]()
    @Published var query = ""
    
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

struct SearchView: View {
    
    @StateObject var vm = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    
                    if vm.results.isEmpty && vm.query.isEmpty {
                        VStack (spacing: 16){
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 60))
                            Text("Please enter your search term above")
                                .font(.system(size: 24,weight: .semibold))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        
                    } else {
                        ScrollView {
                            ForEach(vm.results) { result in
                                VStack(spacing: 16) {
                                    
                                    AppIconTiitleView(result: result)
                                    ScreenshotsRow(proxy: proxy,results: result)
                                }
                                .padding(16)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $vm.query)
        }
    }
}

struct AppIconTiitleView: View {
    
    let result: AppResults
    
    var body: some View {
        HStack(spacing: 16) {
            
            AsyncImage(url: URL(string: result.artworkUrl512)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80,height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } placeholder: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80,height: 80)
            }
            
            VStack(alignment: .leading) {
                Text(result.trackName)
                    .lineLimit(1)
                Text(result.primaryGenreName)
                    .foregroundStyle(.gray)
                Text("STARS 34.0M")
            }
            
            Spacer()
            
            Image(systemName: "icloud.and.arrow.down")
        }
    }
}

struct ScreenshotsRow: View {
    let proxy: GeometryProxy
    let results: AppResults
    var body: some View {
        let width = (proxy.size.width - 4 * 16) / 3
        HStack(spacing: 16) {
            ForEach(results.screenshotUrls.prefix(3), id: \.self) { screenShotsUrl in
                AsyncImage(url:URL(string: screenShotsUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: width ,height: 200)
                }
                
            }
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
