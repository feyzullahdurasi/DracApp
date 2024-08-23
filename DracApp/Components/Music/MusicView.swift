//
//  MusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 19.08.2024.
//

import SwiftUI
import WebKit

struct MusicView: View {
    
    var selectedStreamingService: StreamingService
    
    var body: some View {
        VStack {
            switch selectedStreamingService {
            case .spotify:
                SpotifyView()
            case .youtubeMusic:
                YoutubeMusicView()
            case .appleMusic:
                AppleMusicView()
            case .radio:
                RadioView()
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
    MusicView(selectedStreamingService: .spotify)
}

