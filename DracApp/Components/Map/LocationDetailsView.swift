//
//  LocationDetailsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 24.08.2024.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var isShowDetailMap: Bool
    @State private var lookAraundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                Spacer()
                Button {
                    isShowDetailMap.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            
            
            if let scene = lookAraundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview avaliable", systemImage: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button {
                    getDirections = true
                    isShowDetailMap = false
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            print("Debug: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            print("Debug: Did call on change")
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        lookAraundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapSelection!)
            lookAraundScene = try? await request.scene
        }
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), isShowDetailMap: .constant(false), getDirections: .constant(false))
}
