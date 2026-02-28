//
//  LocationManager.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    typealias Coordinate = LocationModel.Coordinate
    typealias LocationError = LocationModel.LocationError

    func requestLocation() async throws -> Coordinate
}

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<Coordinate, Error>?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
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
        locationContinuation?.resume(returning: Coordinate(coordinate: location.coordinate))
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}

// MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    func requestLocation() async throws -> Coordinate {
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
}

// MARK: - Coordinate Helper
private extension LocationModel.Coordinate {
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude.description
        self.longitude = coordinate.longitude.description
    }
}
