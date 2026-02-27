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
        
        func filterHours() -> [Details.Hour] {
            var filteredHours: [Details.Hour] = []
            let now = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            guard forecast.forecastday.count >= 2 else { return [] }

            let today = forecast.forecastday[0]
            let tomorrow = forecast.forecastday[1]
            
            let remainingTodayHours = today.hour.filter { hour in
                if let hourDate = dateFormatter.date(from: hour.time) {
                    return hourDate >= now
                }
                return false
            }
            filteredHours.append(contentsOf: remainingTodayHours)
            filteredHours.append(contentsOf: tomorrow.hour)
            return filteredHours
        }
    }
}
