//
//  LocationManager.swift
//  DracApp
//
//  Created by Feyzullah Durası on 7.08.2024.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var speed: Double = 0.0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            speed = newLocation.speed >= 0 ? newLocation.speed * 3.6 : 0 // Convert m/s to km/h
        }
    }
}

