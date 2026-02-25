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
    
    private var currentWeatherView = CurrentWeatherView()
    private var testView = ForecastWeatherViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupLayout()
        
        updateWeatherViews()
    }
    
    private func updateWeatherViews() {
        Task {
            await updateActualWeather()
            await updateForecastWeather()
        }
    }
    
    private func setupLayout() {
        view.addSubview(currentWeatherView)
        view.addSubview(testView)

        currentWeatherView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        testView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
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
