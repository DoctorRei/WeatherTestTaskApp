//
//  WeatherViewController.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit
import CoreLocation
import SnapKit

protocol WeatherViewControllerProtocol: AnyObject {
    typealias CurrentModel = WeatherModel.CurrentModel
    typealias ForecastModel = WeatherModel.ForecastModel

    func updateWeatherCollection(current: CurrentModel, forecast: ForecastModel)
}

final class WeatherViewController: UIViewController {
    var presenter: WeatherPresenterProtocol?
    private var weatherCollectionView = WeatherCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(weatherCollectionView)
        
        weatherCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {
    @MainActor
    func updateWeatherCollection(current: CurrentModel, forecast: ForecastModel) {
        weatherCollectionView.configure(with: current, and: forecast)
    }
}
