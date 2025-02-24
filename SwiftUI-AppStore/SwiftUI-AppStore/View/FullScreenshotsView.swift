//
//  FullScreenshotsView.swift
//  SwiftUI-AppStore
//
//  Created by Dmytro Lyshtva on 24.02.2025.
//

import SwiftUI

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
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}



#Preview {
    
    FullScreenshotsView(screenshotsUrl: [
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/9a/96/97/9a969712-ea33-f253-d7c2-40c1b102353b/Op2_iOS5.5_01.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/3d/3b/c6/3d3bc6b4-3bf9-a64a-0815-95ea58c9512c/Op2_iOS5.5_02.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/9c/ba/7c/9cba7c82-deea-9245-5cca-104be6530e4e/Op2_iOS5.5_03.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/5e/dc/44/5edc44ac-ce0a-ea17-44be-96d7036353b2/Op2_iOS5.5_04.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/7d/cd/9d/7dcd9d1d-b3a7-bbe7-003e-e2f73fb0366d/Op2_iOS5.5_05.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/fe/c4/ac/fec4ace5-4919-125f-21bd-3fbe9f514acf/Op2_iOS5.5_06_U0028ROW_U0029.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/f6/57/60/f657606c-589e-27d7-9e98-640fca4ae33e/Op2_iOS5.5_07.jpg/392x696bb.jpg",
                        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/38/23/b0/3823b09d-ea3a-74e2-76f6-ca0832002a51/Op2_iOS5.5_08.jpg/392x696bb.jpg"
                    ]
    )
    
    .preferredColorScheme(.dark)
}
