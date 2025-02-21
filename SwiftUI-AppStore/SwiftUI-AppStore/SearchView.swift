//
//  ContentView.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 11.12.2024.
//

import SwiftUI
import Combine

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
                
                HStack(spacing: 0) {
                    ForEach (0..<Int(result.averageUserRating) , id: \.self) { num in
                        
                        Image(systemName: "star.fill")
                        
                    }
                    
                    ForEach (0..<5 - Int(result.averageUserRating) , id: \.self) { num in
                        
                        Image(systemName: "star")
                        
                    }
                    Text(String(result.userRatingCount.roundedWithAbbreviations))
                        .padding(.leading, 4)
                }
                
                
            }
            
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "icloud.and.arrow.down")
                    .font(.system(size: 25))
            }

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
