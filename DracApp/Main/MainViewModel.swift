//
//  MainViewModel.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var activeViews: Set<ActiveView> = [.maps, .music]  // Varsayılan olarak iki ekran açık
    private let maxActiveViews = 2  // Maksimum aktif görünüm sayısı

    func toggleView(_ view: ActiveView) {
        if activeViews.contains(view) {
            activeViews.remove(view)
        } else {
            if activeViews.count >= maxActiveViews {
                // Küme boyutu sınırını aşıyorsa, en eski görünümü kaldır
                if let oldestView = activeViews.first {
                    activeViews.remove(oldestView)
                }
            }
            activeViews.insert(view)
        }
    }

    func isViewActive(_ view: ActiveView) -> Bool {
        return activeViews.contains(view)
    }

    func handleURL(url: URL) {
        // URL'nin içeriğini çözümleyin
        switch url.scheme {
        case "DracApp":
            // Uygulamanızın özel URL şeması "DracApp" ise işlem yapın
            if let host = url.host {
                switch host {
                case "maps":
                    toggleView(.maps)
                case "youtubeMusic":
                    toggleView(.music)
                default:
                    break
                }
            }
        default:
            break
        }
    }
}
enum StreamingService {
    case spotify
    case youtubeMusic
    case appleMusic
    case radio
}
