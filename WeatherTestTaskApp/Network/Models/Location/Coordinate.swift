//
//  CoordinateModel.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 28.02.2026.
//

extension LocationModel {
    struct Coordinate {
        let latitude: String
        let longitude: String
        
        init(latitude: String, longitude: String) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
