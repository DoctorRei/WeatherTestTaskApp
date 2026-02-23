//
//  WeatherViewController.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit

protocol WeatherViewControllerProtocol: AnyObject {}

final class WeatherViewController: UIViewController {
    var presenter: WeatherAssemblyPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {}
