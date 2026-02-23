//
//  WeatherPresenter.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation

protocol WeatherPresenterProtocol: AnyObject {
    func getWeatherCurrent() async -> WeatherModel?
}

final class WeatherPresenter {
    weak var view: WeatherViewControllerProtocol?
    private var weatherLoaderService: WeatherLoaderServiceProtocol
    
    init(weatherLoaderService: WeatherLoaderServiceProtocol) {
        self.weatherLoaderService = weatherLoaderService
    }
}

extension WeatherPresenter: WeatherPresenterProtocol {
    func getWeatherCurrent() async -> WeatherModel? {
        do {
            let data = try await weatherLoaderService.getWeatherCurrent(style: .current)
            return data
        } catch {
            return nil
        }
    }
}
