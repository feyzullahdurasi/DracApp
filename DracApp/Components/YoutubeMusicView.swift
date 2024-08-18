//
//  YoutubeMusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 10.08.2024.
//

import SwiftUI
import WebKit

struct YoutubeMusicView: View {
    
    var selectedStreamingService: StreamingService
    
    var body: some View {
        VStack {
            switch selectedStreamingService {
            case .spotify:
                SpotifyView()
            case .youtubeMusic:
                WebView(url: URL(string: "https://music.youtube.com/")!)
            }
        }
    }

    private func openYouTubeMusic() {
        let youtubeMusicURL = "youtube-music://playlist/PL9tY0BWXOZFvK2DH1i18zHSjeaRY91I04" // Replace with the desired YouTube Music URL
        if let url = URL(string: youtubeMusicURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/youtube-music/id1017492454") {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    YoutubeMusicView(selectedStreamingService: .spotify)
}

