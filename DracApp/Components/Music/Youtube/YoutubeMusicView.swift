//
//  MusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 10.08.2024.
//

import SwiftUI

struct YoutubeMusicView: View {
    @StateObject private var viewModel = YoutubeMusicViewModel()
    
    var body: some View {
        List(viewModel.videos) { video in
            VStack(alignment: .leading) {
                Text(video.title)
                    .font(.headline)
                if let url = URL(string: video.thumbnailURL) {
                    AsyncImage(url: url)
                        .frame(width: 100, height: 100)
                }
            }
        }
        .onAppear {
            viewModel.fetchMusicVideos(query: "Top Hits")
        }
    }
}
