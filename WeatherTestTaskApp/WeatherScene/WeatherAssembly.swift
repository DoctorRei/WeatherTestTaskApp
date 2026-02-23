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
        let viewController = WeatherViewController()
        let presenter = WeatherPresenter(weatherLoaderService: weatherLoaderSevice)
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
