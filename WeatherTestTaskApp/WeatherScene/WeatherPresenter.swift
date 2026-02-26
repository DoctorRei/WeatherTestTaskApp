//
//  WeatherPresenter.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation

protocol WeatherPresenterProtocol: AnyObject {
    func getWeatherData()
}

final class WeatherPresenter {
    weak var view: WeatherViewControllerProtocol?
    private var weatherLoaderService: WeatherLoaderServiceProtocol
    
    init(weatherLoaderService: WeatherLoaderServiceProtocol) {
        self.weatherLoaderService = weatherLoaderService
    }
}

extension WeatherPresenter: WeatherPresenterProtocol {
    func getWeatherData() {
        Task {
            async let actualWeather = getWeatherCurrent()
            async let forecastWeather = getWeatherForecast()
            
            let (current, forecast) = await (actualWeather, forecastWeather)
            
            guard let current, let forecast else { return }
            view?.updateWeatherCollection(current: current, forecast: forecast)
        }
    }
}

private extension WeatherPresenter {
    func getWeatherCurrent() async -> WeatherModel.CurrentModel? {
        do {
            let data = try await weatherLoaderService.getWeatherCurrent()
            return data
        } catch {
            return nil
        }
    }
    
    func getWeatherForecast() async -> WeatherModel.ForecastModel? {
        do {
            let data = try await weatherLoaderService.getWeatherForecast()
            return data
        } catch {
            return nil
        }
    }
}
