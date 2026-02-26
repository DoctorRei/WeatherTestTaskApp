//
//  WeatherLoaderService.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Moya

protocol WeatherLoaderServiceProtocol: AnyObject {
    func getWeatherCurrent(latitude: String, longitude: String) async throws -> WeatherModel.CurrentModel
    func getWeatherForecast(latitude: String, longitude: String) async throws -> WeatherModel.ForecastModel
}

final class WeatherLoaderService {
    private let logger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private let decoder = JSONDecoder()
    private let provider: MoyaProvider<WeatherTarget>

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        provider = MoyaProvider<WeatherTarget>(plugins: [logger])
    }
}

extension WeatherLoaderService: WeatherLoaderServiceProtocol {
    func getWeatherForecast(latitude: String, longitude: String) async throws -> WeatherModel.ForecastModel {
        let coordinateModel = WeatherTarget.CoordinateModel(latitude: latitude, longitude: longitude)
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.forecast3Days(coordinate: coordinateModel)) { result in
                switch result {
                case .success(let response):
                    do {
                        let weatherModel = try self.decoder.decode(WeatherModel.ForecastModel.self, from: response.data)
                        continuation.resume(returning: weatherModel)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getWeatherCurrent(latitude: String, longitude: String) async throws -> WeatherModel.CurrentModel {
        let coordinateModel = WeatherTarget.CoordinateModel(latitude: latitude, longitude: longitude)
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.current(coordinate: coordinateModel)) { result in
                switch result {
                case .success(let response):
                    do {
                        let weatherModel = try self.decoder.decode(WeatherModel.CurrentModel.self, from: response.data)
                        continuation.resume(returning: weatherModel)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
