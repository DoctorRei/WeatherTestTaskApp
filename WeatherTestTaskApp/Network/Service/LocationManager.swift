//
//  LocationManager.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import Foundation
import CoreLocation

enum LocationError: LocalizedError {
    case authorizationDenied
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "Доступ к геолокации запрещен"
        case .unknown:
            return "Неизвестная ошибка геолокации"
        }
    }
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocation() async throws -> CLLocationCoordinate2D {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return try await withCheckedThrowingContinuation { continuation in
                self.locationContinuation = continuation
            }
            
        case .restricted, .denied:
            throw LocationError.authorizationDenied
            
        case .authorizedWhenInUse, .authorizedAlways:
            return try await withCheckedThrowingContinuation { continuation in
                self.locationContinuation = continuation
                self.locationManager.requestLocation()
            }
            
        @unknown default:
            throw LocationError.unknown
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            
        case .denied, .restricted:
            locationContinuation?.resume(throwing: LocationError.authorizationDenied)
            locationContinuation = nil
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
