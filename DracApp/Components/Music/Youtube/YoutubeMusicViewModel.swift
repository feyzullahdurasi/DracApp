//
//  YoutubeMusicViewModel.swift
//  DracApp
//
//  Created by Feyzullah Durası on 19.08.2024.
//

import SwiftUI
import Combine
import YouTubePlayerKit

class YoutubeMusicViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var youTubePlayer: YouTubePlayer?
    private let api = YouTubeAPI()
    
    func fetchMusicVideos(query: String = "Top Music") {
        api.fetchMusicVideos(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videos):
                    self?.videos = videos
                    self?.playRandomVideo()
                case .failure(let error):
                    print("Error fetching music videos: \(error)")
                }
            }
        }
    }
    
    func playRandomVideo() {
        guard !videos.isEmpty else { return }
        let randomVideo = videos.randomElement()
        if let videoId = randomVideo?.id {
            self.youTubePlayer = YouTubePlayer(
                source: .video(id: videoId),
                configuration: .init(
                    autoPlay: true,
                    showControls: false
                )
            )
        }
    }
}
