//
//  ComponentsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI
import MapKit

struct GenericView: View {
    @Binding var isShowing: Bool
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
        }
    }
}

struct ContactsView: View {
    @Binding var showContacts: Bool
    
    var body: some View {
        GenericView(isShowing: $showContacts, title: "Contacts View")
    }
}

struct YoutubeMusicHomepageView: View {
    var body: some View {
        YoutubeMusicHomepageView() // Updated to use the new view
            
    }
}

struct InstagramView: View {
    @Binding var showInstagram: Bool
    
    var body: some View {
        GenericView(isShowing: $showInstagram, title: "Instagram View")
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
}
