//
//  LocationManager.swift
//  DracApp
//
//  Created by Feyzullah Durası on 7.08.2024.
//

import MapKit

// LocationManager to track user's current location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    @Published var speed: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            region = MKCoordinateRegion(center: location.coordinate, span: span)
        }
        if let newLocation = locations.last {
            speed = newLocation.speed >= 0 ? newLocation.speed * 3.6 : 0 // Convert m/s to km/h
        }
    }
}
