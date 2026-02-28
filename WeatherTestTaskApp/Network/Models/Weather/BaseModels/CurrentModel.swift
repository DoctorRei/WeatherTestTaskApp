//
//  WeatherCurrentModel.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation

extension WeatherModel {
    struct CurrentModel: Decodable {
        let location: Details.Location
        let current: Details.Current
    }
}
