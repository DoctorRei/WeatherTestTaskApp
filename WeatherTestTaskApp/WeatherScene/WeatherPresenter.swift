//
//  WeatherPresenter.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation

protocol WeatherPresenterProtocol: AnyObject {
    func getWeatherCurrent() async -> WeatherModel.CurrentModel?
}

final class WeatherPresenter {
    weak var view: WeatherViewControllerProtocol?
    private var weatherLoaderService: WeatherLoaderServiceProtocol
    
    init(weatherLoaderService: WeatherLoaderServiceProtocol) {
        self.weatherLoaderService = weatherLoaderService
    }
}

extension WeatherPresenter: WeatherPresenterProtocol {
    func getWeatherCurrent() async -> WeatherModel.CurrentModel? {
        do {
            let data = try await weatherLoaderService.getWeatherCurrent()
            return data
        } catch {
            return nil
        }
    }
}
