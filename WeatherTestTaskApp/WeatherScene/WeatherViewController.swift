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
    private enum Const {
        enum Color {
            static let backgroundColor: UIColor = .blue.withAlphaComponent(0.1)
        }
        
        static let animationDuration: CGFloat = 0.2
    }
    
    var presenter: WeatherPresenterProtocol?
    private var weatherCollectionView = WeatherCollectionView()
    private var loader = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupLayout()
        loader.start()
        view.backgroundColor = Const.Color.backgroundColor
    }
    
    private func setupLayout() {
        view.addSubview(weatherCollectionView)
        view.addSubview(loader)
        
        weatherCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        loader.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {
    @MainActor
    func updateWeatherCollection(current: CurrentModel, forecast: ForecastModel) {
        loader.stop()
        UIView.animate(withDuration: Const.animationDuration) {
            self.loader.alpha = 0
        }
        weatherCollectionView.configure(with: current, and: forecast)
    }
}
