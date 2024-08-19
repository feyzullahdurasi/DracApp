//
//  AppleMusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 19.08.2024.
//

import SwiftUI
import MusicKit

struct AppleMusicView: View {
    @State private var songs: [Song] = []
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationView {
            List(songs, id: \.id) { song in
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Apple Music")
        }
        .onAppear {
            fetchAppleMusicSongs()
        }
    }
    
    private func fetchAppleMusicSongs() {
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: "Your Search Term", types: [Song.self])
                let response = try await request.response()
                songs = response.songs.compactMap { $0 }
            } catch {
                print("Failed to fetch songs: \(error)")
            }
        }
    }
}
#Preview {
    AppleMusicView()
}
