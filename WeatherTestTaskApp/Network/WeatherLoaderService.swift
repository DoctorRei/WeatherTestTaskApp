//
//  WeatherLoaderService.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Moya

protocol WeatherLoaderServiceProtocol: AnyObject {
    func getWeatherCurrent(style: WeatherTarget) async throws -> WeatherModel
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
    func getWeatherCurrent(style: WeatherTarget) async throws -> WeatherModel {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(style) { result in
                switch result {
                case .success(let response):
                    do {
                        let weatherModel = try self.decoder.decode(WeatherModel.self, from: response.data)
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
