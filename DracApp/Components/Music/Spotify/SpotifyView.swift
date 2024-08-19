//
//  SpotifyView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 12.08.2024.
//

import SwiftUI

struct SpotifyView: View {
    @StateObject private var viewModel = SpotifyViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.isConnected {
                VStack {
                    if let image = viewModel.trackImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                    
                    Text(viewModel.trackName)
                        .font(.title)
                    
                    HStack {
                        Button(action: {
                            viewModel.didTapPreviousTrack()
                        }) {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                        
                        Button(action: {
                            viewModel.didTapPauseOrPlay()
                        }) {
                            Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                        
                        Button(action: {
                            viewModel.didTapNextTrack()
                        }) {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                    }
                }
            } else {
                Button("Connect with Spotify") {
                    viewModel.connect()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .onAppear {
            // Check initial state or perform other setup if needed
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .background(.purple)  // Arka plan rengini siyah yap
        .foregroundColor(.white)  // Yazı rengini beyaz yap
        
    }
}

#Preview {
    SpotifyView()
}
