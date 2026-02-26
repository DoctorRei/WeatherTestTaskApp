//
//  WeatherAssembly.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit

protocol WeatherAssemblyProtocol {
    func configure() -> WeatherViewController
}

final class WeatherAssembly: WeatherAssemblyProtocol {
    func configure() -> WeatherViewController {
        let weatherLoaderSevice = WeatherLoaderService()
        let locationManager = LocationManager()
        let viewController = WeatherViewController()
        let presenter = WeatherPresenter(weatherLoaderService: weatherLoaderSevice, locationManager: locationManager)
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
