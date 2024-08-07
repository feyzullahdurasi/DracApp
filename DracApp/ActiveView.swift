//
//  MapsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 3.08.2024.
//

import SwiftUI

enum ActiveView: CaseIterable {
    case maps, contacts, youtube, instagram, settings
    
    var systemImageName: String {
        switch self {
        case .maps: return "map"
        case .contacts: return "phone"
        case .youtube: return "music.note"
        case .instagram: return "car.fill"
        case .settings: return "gearshape"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .maps: return .blue
        case .contacts: return .green
        case .youtube: return .purple
        case .instagram: return .orange
        case .settings: return .brown
        }
    }
}

