//
//  WeatherPresenter.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Foundation

protocol WeatherAssemblyPresenter: AnyObject {}

final class WeatherPresenter: WeatherAssemblyPresenter {
    weak var view: WeatherViewControllerProtocol?
}
