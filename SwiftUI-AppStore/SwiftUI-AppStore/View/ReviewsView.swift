//
//  ReviewsView.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 25.02.2025.
//

import SwiftUI

struct ReviewsView: View {
    let proxy: GeometryProxy
    
    @State var vm: ReviewsViewModel
    let trackId: Int
    
    init(trackId: Int, proxy: GeometryProxy) {
        self._vm = .init(wrappedValue: ReviewsViewModel(trackId: trackId))
        self.trackId = trackId
        self.proxy = proxy
    }
    
    
    var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 16){
                    ForEach(vm.entries) { review in
                        VStack(alignment: .leading, spacing: 16){
                            HStack{
                                Text(review.title.label)
                                    .lineLimit(1)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Text(review.author.name.label)
                                    .lineLimit(1)
                                    .foregroundStyle(.gray)
                            }
                            
                            HStack(spacing:0){
                                ForEach(0..<(Int(review.rating.label) ?? 0), id: \.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.orange)
                                }
                                
                                ForEach(0..<5 - (Int(review.rating.label) ?? 0), id: \.self) { num in
                                    Image(systemName: "star")
                                        .foregroundStyle(.orange)
                                }
                            }

                            
                            Text(review.content.label)
                            Spacer()
                        }
                        .padding(20)
                        .frame(width: proxy.size.width - 64,height: 230)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 16)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    GeometryReader{ proxy in
        ReviewsView(trackId: 547702041, proxy: proxy)
            .preferredColorScheme(.dark)
    }
}
