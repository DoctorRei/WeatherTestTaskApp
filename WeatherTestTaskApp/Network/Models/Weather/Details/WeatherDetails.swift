//
//  WeatherModels.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 24.02.2026.
//

import Foundation

extension WeatherModel {
    enum Details {
        struct Location: Decodable {
            let name: String
            let region: String
            let country: String
            let lat: Double
            let lon: Double
            let tzId: String
            let localtimeEpoch: Int
            let localtime: String
        }

        struct Current: Decodable {
            let lastUpdatedEpoch: Int
            let lastUpdated: String
            let tempC: Double
            let tempF: Double
            let isDay: Int
            let condition: Condition
            let windMph: Double
            let windKph: Double
            let windDegree: Int
            let windDir: String
            let pressureMb: Double
            let pressureIn: Double
            let precipMm: Double
            let precipIn: Double
            let humidity: Int
            let cloud: Int
            let feelslikeC: Double
            let feelslikeF: Double
            let windchillC: Double
            let windchillF: Double
            let heatindexC: Double
            let heatindexF: Double
            let dewpointC: Double
            let dewpointF: Double
            let visKm: Double
            let visMiles: Double
            let uv: Double
            let gustMph: Double
            let gustKph: Double
        }

        struct Condition: Decodable {
            let text: String
            let icon: String
            let code: Int

            var iconURL: URL? {
                let baseURL = "https:\(icon)"
                return URL(string: baseURL)
            }
        }

        struct Forecast: Decodable {
            let forecastday: [ForecastDay]
        }

        struct ForecastDay: Decodable {
            let date: String
            let dateEpoch: Int
            let day: Day
            let astro: Astro
            let hour: [Hour]
        }

        struct Day: Decodable {
            let maxtempC: Double
            let maxtempF: Double
            let mintempC: Double
            let mintempF: Double
            let avgtempC: Double
            let avgtempF: Double
            let maxwindMph: Double
            let maxwindKph: Double
            let totalprecipMm: Double
            let totalprecipIn: Double
            let totalsnowCm: Double
            let avgvisKm: Double
            let avgvisMiles: Double
            let avghumidity: Int
            let dailyWillItRain: Int
            let dailyChanceOfRain: Int
            let dailyWillItSnow: Int
            let dailyChanceOfSnow: Int
            let condition: Condition
            let uv: Double
        }

        struct Astro: Decodable {
            let sunrise: String
            let sunset: String
            let moonrise: String
            let moonset: String
            let moonPhase: String
            let moonIllumination: Int
            let isMoonUp: Int
            let isSunUp: Int
        }

        struct Hour: Decodable {
            let timeEpoch: Int64
            let time: String
            let tempC: Double
            let tempF: Double
            let isDay: Int
            let condition: Condition
            let windMph: Double
            let windKph: Double
            let windDegree: Int
            let windDir: String
            let pressureMb: Double
            let pressureIn: Double
            let precipMm: Double
            let precipIn: Double
            let snowCm: Double
            let humidity: Int
            let cloud: Int
            let feelslikeC: Double
            let feelslikeF: Double
            let windchillC: Double
            let windchillF: Double
            let heatindexC: Double
            let heatindexF: Double
            let dewpointC: Double
            let dewpointF: Double
            let willItRain: Int
            let chanceOfRain: Int
            let willItSnow: Int
            let chanceOfSnow: Int
            let visKm: Double
            let visMiles: Double
            let gustMph: Double
            let gustKph: Double
            let uv: Double

            func getTime() -> String {
                let time = TimeInterval(integerLiteral: timeEpoch)
                let date = Date(timeIntervalSince1970: time)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: date)

                return timeString
            }
        }
    }
}
