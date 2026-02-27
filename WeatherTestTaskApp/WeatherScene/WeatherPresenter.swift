//
//  WeatherPresenter.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation
import CoreLocation

protocol WeatherPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class WeatherPresenter {
    enum Const {
        static let moscowCoordinates = CLLocationCoordinate2D(
            latitude: 55.7558,
            longitude: 37.6176
        )
    }
    
    weak var view: WeatherViewControllerProtocol?
    private var weatherLoaderService: WeatherLoaderServiceProtocol?
    private var locationManager: LocationManagerProtocol?
    
    init(weatherLoaderService: WeatherLoaderServiceProtocol, locationManager: LocationManagerProtocol) {
        self.weatherLoaderService = weatherLoaderService
        self.locationManager = locationManager
    }
}

extension WeatherPresenter: WeatherPresenterProtocol {
    func viewDidLoad() {
        Task { [weak self] in
            await self?.handleLocationAndWeather()
        }
    }
    
    private func handleLocationAndWeather() async {
        do {
            guard let coordinate = try await locationManager?.requestLocation() else { return }
            getWeatherData(with: coordinate)
        } catch LocationError.authorizationDenied {
            getWeatherData(with: Const.moscowCoordinates)
        } catch {
            getWeatherData(with: Const.moscowCoordinates)
        }
    }
    
    func getWeatherData(with coordinate: CLLocationCoordinate2D) {
        Task {
            async let actualWeather = getWeatherCurrent(with: coordinate)
            async let forecastWeather = getWeatherForecast(with: coordinate)
            
            let (current, forecast) = await (actualWeather, forecastWeather)
            
            guard let current, let forecast else {
                view?.showError()
                return
            }
            view?.updateWeatherCollection(current: current, forecast: forecast)
        }
    }
}

private extension WeatherPresenter {
    func getWeatherCurrent(with coordinate: CLLocationCoordinate2D) async -> WeatherModel.CurrentModel? {
        do {
            let data = try await weatherLoaderService?.getWeatherCurrent(
                latitude: coordinate.latitude.description,
                longitude: coordinate.longitude.description
            )
            return data
        } catch {
            return nil
        }
    }
    
    func getWeatherForecast(with coordinate: CLLocationCoordinate2D) async -> WeatherModel.ForecastModel? {
        do {
            let data = try await weatherLoaderService?.getWeatherForecast(
                latitude: coordinate.latitude.description,
                longitude: coordinate.longitude.description
            )
            return data
        } catch {
            return nil
        }
    }
}
