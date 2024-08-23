//
//  MusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 10.08.2024.
//

import SwiftUI
import Combine
import YouTubePlayerKit

struct YoutubeMusicView: View {
    @StateObject private var viewModel = YoutubeMusicViewModel()
    @State private var selectedVideo: Video?
    @State private var videoDuration: Measurement<UnitDuration> = Measurement(value: 0, unit: .seconds)
    @State private var currentTime: Measurement<UnitDuration> = Measurement(value: 0, unit: .seconds)
       
    var body: some View {
        VStack {
            List(viewModel.videos) { video in
                VStack {
                    if let url = URL(string: video.thumbnailURL) {
                        AsyncImage(url: url)
                            .frame(width: 100, height: 100)
                    }
                    Text(video.title)
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }.onTapGesture {
                    selectedVideo = video
                }
            }
            VStack {
                Text("Duration: \(Int(videoDuration.value)) seconds")
                    .onReceive(viewModel.youTubePlayer?.durationPublisher ?? Just(Measurement(value: 0, unit: UnitDuration.seconds)).eraseToAnyPublisher()) { duration in
                        self.videoDuration = duration
                    }
                
                Text("Current Time: \(Int(currentTime.value)) seconds")
                    .onReceive(viewModel.youTubePlayer?.currentTimePublisher() ?? Just(Measurement(value: 0, unit: UnitDuration.seconds)).eraseToAnyPublisher()) { time in
                        self.currentTime = time
                    }
                
                Color.clear
                    .frame(height: 0)
                
                YouTubePlayerView(viewModel.youTubePlayer ?? YouTubePlayer(source: .none))
                    .opacity(0)
                
                Button(action: {
                    viewModel.youTubePlayer?.pause()
                }) {
                    Text("Pause")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchMusicVideos()
        }
        .sheet(item: $selectedVideo) { video in
            VideoDetailView(video: video)
        }
    }
}

#Preview {
    YoutubeMusicView()
}
