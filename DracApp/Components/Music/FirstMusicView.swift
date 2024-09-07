//
//  FirstMusicView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 10.08.2024.
//

import SwiftUI

struct FirstMusicView: View {
    @Binding var isShowingFirstLaunchView: Bool
       
       var body: some View {
           VStack(spacing: 20) {
               Text("Choose your music playback service")
                   .font(.title)
                   .multilineTextAlignment(.center)
                   .padding()
               
               Button("Spotify") {
                   saveUserPreference(service: .spotify)
                   isShowingFirstLaunchView = false
               }
               .padding()
               .background(Color.green)
               .foregroundColor(.white)
               .cornerRadius(10)
               
               Button("YouTube Music") {
                   saveUserPreference(service: .youtubeMusic)
                   isShowingFirstLaunchView = false
               }
               .padding()
               .background(Color.red)
               .foregroundColor(.white)
               .cornerRadius(10)
               
               Button("Apple Music") {
                   saveUserPreference(service: .appleMusic)
                   isShowingFirstLaunchView = false
               }
               .padding()
               .background(Color.red)
               .foregroundColor(.white)
               .cornerRadius(10)
           }
           .padding()
       }
       
       private func saveUserPreference(service: StreamingService) {
           let serviceString: String
           switch service {
           case .spotify:
               serviceString = "spotify"
           case .youtubeMusic:
               serviceString = "youtubeMusic"
           case .appleMusic:
               serviceString = "appleMusic"
           case .radio:
               serviceString = "radio"
           }
           UserDefaults.standard.set(serviceString, forKey: "preferredStreamingService")
       }
}

#Preview {
    FirstMusicView(isShowingFirstLaunchView: .constant(true))
}
