//
//  CoordinateError.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 28.02.2026.
//

import Foundation

extension LocationModel {
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
}
