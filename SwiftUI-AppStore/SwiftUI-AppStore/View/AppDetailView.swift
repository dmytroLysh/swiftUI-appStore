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

@Observable
class DetailViewModel: ObservableObject {
    
    private let trackId: Int
     var appDetail: AppDetail?
     var eror: Error?
    
    init(trackId: Int) {
        self.trackId = trackId
        fetchJsonData()
    }
    
    private func fetchJsonData(){
        Task {
            do {
                self.appDetail = try await APIService.fetchAppDetail(trackID: trackId)
            } catch {
                self.eror = error
            }
        }
    }
    
}

struct AppDetailView: View {
    
    @State var vm: DetailViewModel
    @State var isPresentingFullScreenScreenshots = false
    
    init(trackId: Int) {
        self._vm = .init(wrappedValue: DetailViewModel(trackId: trackId))
        self.trackId = trackId
    }
    
    let trackId: Int
    
    var body: some View {
        GeometryReader{ proxy in
            
            if vm.eror != nil {
                Text("Failed to fetch data detail")
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
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
                        Text("Reviews")
                            .font(.system(size: 24,weight: .semibold))
                            .padding(.vertical)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    ReviewsView(trackId: self.trackId, proxy: proxy)
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.system(size: 24,weight: .semibold))
                            .padding(.vertical)
                        Text(appDetail.description)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        AppDetailView(trackId: 547702041)
    }
    .preferredColorScheme(.dark)
}
