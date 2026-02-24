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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupLayout()
        
        Task {
            await updateActualWeather()
            await updateForecastWeather()
        }
    }
    
    private func setupLayout() {
        view.addSubview(currentWeatherView)

        currentWeatherView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
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
        print("TESTTEST \(data)")
    }
}
