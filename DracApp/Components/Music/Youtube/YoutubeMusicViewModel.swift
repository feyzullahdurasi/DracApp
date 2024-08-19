//
//  YoutubeMusicViewModel.swift
//  DracApp
//
//  Created by Feyzullah Durası on 19.08.2024.
//

import SwiftUI

class YoutubeMusicViewModel: ObservableObject {
    @Published var videos: [Video] = []
    private let apiKey = "YOUR_API_KEY"
    
    func fetchMusicVideos(query: String) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&type=video&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.videos = decodedResponse.items
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            }
        }.resume()
    }
}

struct Video: Identifiable, Decodable {
    let id: String
    let title: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "snippet.title"
        case thumbnailURL = "snippet.thumbnails.default.url"
    }
}

struct YouTubeResponse: Decodable {
    let items: [Video]
}
