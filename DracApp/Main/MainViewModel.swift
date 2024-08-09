//
//  MainViewModel.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var activeViews: Set<ActiveView> = [.youtube]  // Varsayılan olarak iki ekran açık
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
}
