//
//  MusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 10.08.2024.
//

import SwiftUI

struct YoutubeMusicView: View {
    @StateObject private var viewModel = YoutubeMusicViewModel()
    @State private var selectedVideo: Video?
    
    var body: some View {
        VStack {
            Button("Play Random Music Video") {
                if let randomVideo = viewModel.playRandomMusicVideo() {
                    selectedVideo = randomVideo
                }
            }
            List(viewModel.videos) { video in
                VStack() {
                    if let url = URL(string: video.thumbnailURL) {
                        AsyncImage(url: url)
                            .frame(width: 100, height: 100)
                    }
                    Text(video.title)
                        .font(.headline)
                }.onTapGesture {
                    selectedVideo = video
                }
            }
        }
        .onAppear {
            viewModel.fetchUserMusicVideos()
        }
        .sheet(item: $selectedVideo) { video in
            VideoDetailView(video: video)
        }
    }
}

#Preview {
    YoutubeMusicView()
}
