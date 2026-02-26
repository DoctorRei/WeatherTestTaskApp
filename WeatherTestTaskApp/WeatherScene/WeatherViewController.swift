//
//  WeatherViewController.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit
import SnapKit

protocol WeatherViewControllerProtocol: AnyObject {
    func updateActualWeather() async
    func updateForecastWeather() async
}

final class WeatherViewController: UIViewController {
    var presenter: WeatherPresenterProtocol?
    
    private var currentWeatherView = CurrentWeatherCell()
    private var testView = ForecastWeatherViewCell()
    private var weatherCollectionView = WeatherCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadWeatherData()
    }
    
    private func updateWeatherViews() {
        Task {
            await updateActualWeather()
            await updateForecastWeather()
        }
    }
    
    func loadWeatherData() {
        Task {
            async let actualWeather = presenter?.getWeatherCurrent()
            async let forecastWeather = presenter?.getWeatherForecast()
            
            let (current, forecast) = await (actualWeather, forecastWeather)
            
            guard let current, let forecast else { return }
            await MainActor.run {
                weatherCollectionView.configure(with: current, and: forecast)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(weatherCollectionView)
        
        weatherCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {
    func updateActualWeather() async {
        guard let data = await presenter?.getWeatherCurrent() else { return }
        currentWeatherView.configure(with: data)
    }
    
    func updateForecastWeather() async {
        guard let data = await presenter?.getWeatherForecast() else { return }
        guard let hour = data.forecast.forecastday.first?.hour.first else { return }
        
        testView.configure(with: hour)
    }
}
