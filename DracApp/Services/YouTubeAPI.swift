//
//  DataService.swift
//  DracApp
//
//  Created by Feyzullah Durası on 21.08.2024.
//

import Foundation

struct YouTubeAPI {
    private let apiKey = "AIzaSyAr_Mt1dNZkncYUG9D1teKL9OLhG5cHMws"
    
    func fetchMusicVideos(query: String, completion: @escaping (Result<[Video], Error>) -> Void) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&type=video&videoCategoryId=10&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.unknown)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                let videos = decodedResponse.items.map { item in
                    Video(
                        id: item.id.videoId,
                        title: item.snippet.title,
                        thumbnailURL: item.snippet.thumbnails.default.url
                    )
                }
                completion(.success(videos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct Video: Identifiable {
    let id: String
    let title: String
    let thumbnailURL: String
}

struct YouTubeResponse: Decodable {
    let items: [VideoItem]
}

struct VideoItem: Decodable {
    let id: VideoId
    let snippet: VideoSnippet
}

struct VideoId: Decodable {
    let videoId: String
}

struct VideoSnippet: Decodable {
    let title: String
    let thumbnails: VideoThumbnails
}

struct VideoThumbnails: Decodable {
    let `default`: ThumbnailDetails
}

struct ThumbnailDetails: Decodable {
    let url: String
}
