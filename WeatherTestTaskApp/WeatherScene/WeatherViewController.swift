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
}

final class WeatherViewController: UIViewController {
    var presenter: WeatherPresenterProtocol?
    
    private var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupLayout()
        
        Task {
            await updateActualWeather()
        }
    }
    
    private func setupLayout() {
        view.addSubview(weatherLabel)

        weatherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {
    func updateActualWeather() async {
        let data = await presenter?.getWeatherCurrent()
        
        weatherLabel.text = data
    }
}
