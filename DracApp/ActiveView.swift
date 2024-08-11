//
//  MapsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 3.08.2024.
//

import SwiftUI

enum ActiveView: CaseIterable {
    case maps, contacts, youtubeMusic, instagram, speed
    
    var systemImageName: String {
        switch self {
        case .maps: return "map"
        case .contacts: return "phone"
        case .youtubeMusic: return "music.note"
        case .instagram: return "car.fill"
        case .speed: return "gauge.with.dots.needle.67percent"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .maps: return .blue
        case .contacts: return .green
        case .youtubeMusic: return .purple
        case .instagram: return .orange
        case .speed: return .red
        }
    }
}

