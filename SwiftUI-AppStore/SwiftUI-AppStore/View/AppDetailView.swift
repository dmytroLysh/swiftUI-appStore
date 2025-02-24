//
//  AppDetailView.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 24.02.2025.
//

import SwiftUI
import Combine


struct AppDetailResults: Codable {
    let results: [AppDetail]
}

struct AppDetail: Codable {
    let artworkUrl512: String
    let releaseNotes: String
    let version: String
    let description: String
    let screenshotUrls: [String]
    let artistName: String
    let trackName: String
}

@MainActor
class DetailViewModel: ObservableObject {
    
    private let trackId: Int
    @Published var appDetail: AppDetail?
    
    init(trackId: Int) {
        self.trackId = trackId
        fetchJsonData()
    }
    
    private func fetchJsonData(){
        Task {
            do {
                guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(trackId)") else { return }
                
                let(data, _) =  try await  URLSession.shared.data(from: url)
                let appDetailResults = try JSONDecoder().decode(AppDetailResults.self, from: data)
                
                self.appDetail = appDetailResults.results.first
                
            } catch {
                print("Failed fethc app detail", error)
            }
        }
    }
    
}

struct AppDetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State var isPresentingFullScreenScreenshots = false
    
    init(trackId: Int) {
        self._vm = .init(wrappedValue: DetailViewModel(trackId: trackId))
        self.trackId = trackId
    }
    
    let trackId: Int
    
    var body: some View {
        ScrollView {
            if let appDetail = vm.appDetail {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: appDetail.artworkUrl512)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100,height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 100,height: 100)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(appDetail.trackName)
                            .font(.system(size: 24,weight: .semibold))
                        Text(appDetail.artistName)
                            .foregroundStyle(.gray)
                        
                        Button {
                        } label: {
                            Image(systemName: "icloud.and.arrow.down")
                                .font(.system(size: 24))
                                .padding(.vertical)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("What's new")
                            .font(.system(size: 24,weight: .semibold))
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            Text("Version History")
                        }
                        
                    }
                    Text(appDetail.releaseNotes)
                }
                .padding(.horizontal)
                
                Text("Preview")
                    .font(.system(size: 24,weight: .semibold))
                    .padding(.vertical)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(appDetail.screenshotUrls, id: \.self) { screenshotUrl in
                            
                            Button {
                                isPresentingFullScreenScreenshots.toggle()
                            } label: {
                                AsyncImage(url: URL(string: screenshotUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200,height: 350)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(width: 200, height: 350)
                                }
                            }

                            
                        }
                    }
                    .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $isPresentingFullScreenScreenshots) {
                    FullScreenshotsView(screenshotsUrl: appDetail.screenshotUrls)
                }
                
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.system(size: 24,weight: .semibold))
                        .padding(.vertical)
                    Text(appDetail.description)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FullScreenshotsView: View {
    @Environment(\.dismiss) var dismiss
    let screenshotsUrl: [String]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.foreground)
                            .font(.system(size: 25, weight: .semibold))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(screenshotsUrl, id:\.self) { screenshotUrl in
                            let width = proxy.size.width - 64
                            
                            AsyncImage(url: URL(string: screenshotUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width,height: 550)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: width, height: 550)
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppDetailView(trackId: 547702041)
    }
    .preferredColorScheme(.dark)
}
