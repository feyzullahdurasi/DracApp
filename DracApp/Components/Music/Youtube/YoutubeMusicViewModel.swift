//
//  YoutubeMusicViewModel.swift
//  DracApp
//
//  Created by Feyzullah Durası on 19.08.2024.
//

import SwiftUI
import AVKit

class YoutubeMusicViewModel: ObservableObject {
    @Published var videos: [Video] = []
    private let apiKey = "AIzaSyAr_Mt1dNZkncYUG9D1teKL9OLhG5cHMws" // Bu değeri geçerli API anahtarıyla değiştirin.
    private var player: AVPlayer?
    
    func fetchMusicVideos(query: String) {
        let playlistId = "USER_PLAYLIST_ID"
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&type=video&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    // Öncelikle hatayı kontrol edelim
                    let decodedResponse = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.videos = decodedResponse.items
                        self.playRandomVideo()
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else if let error = error {
                print("Error with data task: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func playRandomMusicVideo() -> Video? {
        return videos.randomElement()
    }
    
    func playRandomVideo() {
        guard !videos.isEmpty else { return }
        let randomVideo = videos.randomElement()
        if let videoId = randomVideo?.id {
            playVideo(videoId: videoId)
        }
    }
    
    private func playVideo(videoId: String) {
        let videoURLString = "https://www.youtube.com/watch?v=\(videoId)"
        guard let url = URL(string: videoURLString) else { return }
        player = AVPlayer(url: url)
        player?.play()
    }
}

struct Video: Identifiable, Decodable {
    let id: String
    let title: String
    let videoId: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    enum IdKeys: String, CodingKey {
        case videoId
    }
    
    enum SnippetKeys: String, CodingKey {
        case title
        case thumbnails
    }
    
    enum ThumbnailsKeys: String, CodingKey {
        case `default`
    }
    
    enum DefaultKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // `videoId`'yi `id` anahtarından alıyoruz
        let idContainer = try container.nestedContainer(keyedBy: IdKeys.self, forKey: .id)
        self.videoId = try idContainer.decode(String.self, forKey: .videoId)
        
        // `title`'ı `snippet` anahtarından alıyoruz
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        
        // `thumbnailURL`'i `thumbnails` anahtarından alıyoruz
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsKeys.self, forKey: .thumbnails)
        let defaultContainer = try thumbnailsContainer.nestedContainer(keyedBy: DefaultKeys.self, forKey: .default)
        self.thumbnailURL = try defaultContainer.decode(String.self, forKey: .url)
        
        // `id` alanını `videoId` ile aynı yapıyoruz
        self.id = self.videoId
    }
}

struct YouTubeResponse: Decodable {
    let items: [Video]
}
