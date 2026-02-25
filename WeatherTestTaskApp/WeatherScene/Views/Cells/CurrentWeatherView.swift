//
//  CurrentWeatherView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit
import SnapKit

// - Отобразить один экран с погодной информацией: текущая, почасовая (показывать оставшиеся часы из текущего дня и все часы следующего), прогноз погоды на 3 дня.
// - Обработать показ загрузки и ошибку, если что-то пошло не так, с кнопкой повторного запроса
// - По дизайну никаких ограничений нет, можно ориентироваться на погодное приложение Apple

/// Город
/// Страна
/// Слева градусы

final class CurrentWeatherView: UIView {
    private enum Const {
        static let cityLabelFontSize: CGFloat = 18
        static let countryLabelFontSize: CGFloat = 16
        static let temperatureLabelFontSize: CGFloat = 40
        
        static let locationStackSpacing: CGFloat = 2
        static let temperatureStackSpacing: CGFloat = 4
        static let currentWeatherStackInset: CGFloat = 8
        
        static let celsiusImageSize: CGSize = .init(width: 30, height: 24)
        static let temperatureImageSize: CGFloat = 40
    }
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Const.cityLabelFontSize)
        return label
    }()
    
    private var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: Const.countryLabelFontSize)
        return label
    }()
    
    private var tempertureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: Const.temperatureLabelFontSize)
        
        return label
    }()
    
    private var temperatureImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var locationInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Const.locationStackSpacing
        return stackView
    }()
    
    private var currentWeatherStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private var temperatureStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Const.temperatureStackSpacing
        stackView.alignment = .lastBaseline
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        setupLayer()
        currentWeatherStack.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WeatherModel.CurrentModel) {
        cityLabel.text = model.location.name
        countryLabel.text = model.location.country
        tempertureLabel.createTextWithCelsiusIcon(model.current.tempC, iconSize: Const.celsiusImageSize)
        temperatureImage.kfDownloadImage(withURL: model.current.condition.iconURL)
    }
    
    // TODO: - Сделать что-то получше
    private func setupLayer() {
        layer.borderWidth = 2
        layer.borderColor = .init(red: 100, green: 0, blue: 100, alpha: 1)
        layer.cornerRadius = 8
    }
    
    private func setupLayout() {
        locationInfoStack.addArrangedSubviews(cityLabel, countryLabel)
        temperatureStack.addArrangedSubviews(temperatureImage, tempertureLabel)
        currentWeatherStack.addArrangedSubviews(locationInfoStack, temperatureStack)
        
        temperatureImage.snp.makeConstraints { make in
            make.size.equalTo(Const.temperatureImageSize)
        }
        
        addSubview(currentWeatherStack)
        
        currentWeatherStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Const.currentWeatherStackInset)
        }
    }
}
