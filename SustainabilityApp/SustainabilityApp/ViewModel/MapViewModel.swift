//
//  MapViewModel.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import Foundation
import MapKit
import Combine

/// Simple async MapKit search service
final class MapSearchService {
    /// Perform a local search for `query` within `region`. Returns MKMapItem results.
    func search(query: String, region: MKCoordinateRegion?) async throws -> [MKMapItem] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let r = region {
            request.region = r
        }
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        return response.mapItems
    }
}

/// Observable location manager for SwiftUI integration.
final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Request location permission when the app is in use.
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    /// Start updating user location (after permission granted).
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    /// Stop updating location when not needed.
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
}

