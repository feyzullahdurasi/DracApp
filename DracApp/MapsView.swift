//
//  MapsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 3.08.2024.
//

import SwiftUI
import MapKit

struct MapsView: View {
    
    @Binding var showMaps: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showMaps = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .padding()
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 10)
            MapView(region: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
                .edgesIgnoringSafeArea(.all)
        }
    }}


