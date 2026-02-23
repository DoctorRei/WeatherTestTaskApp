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
    private let provider = MoyaProvider<WeatherTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
                        print("TESTTEST1 Decode failure: \(error) STATUSCODE \(response.statusCode), description \(response.description), data \(response.data)")
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    print("TESTTEST3 \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
