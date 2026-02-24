//
//  ForecastModel.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 24.02.2026.
//

import Foundation

extension WeatherModel {
    struct ForecastModel: Decodable {
        let location: Details.Location
        let current: Details.Current
        let forecast: Details.Forecast
    }
}
