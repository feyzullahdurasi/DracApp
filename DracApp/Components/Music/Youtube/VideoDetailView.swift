//
//  VideoDetailView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 21.08.2024.
//

import SwiftUI
import YouTubePlayerKit

struct VideoDetailView: View {
    var video: Video
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .leading) {
                let youTubePlayer = YouTubePlayer(
                    source: .video(id: video.thumbnailURL),
                    configuration: .init(
                        autoPlay: true
                    )
                )
                YouTubePlayerView(youTubePlayer)
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.3)
            }
        }
    }
}
