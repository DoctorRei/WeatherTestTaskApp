//
//  WeatherBy3Days.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class ForecastWeatherForThreeDaysCell: UICollectionViewCell {
    static var identifire: String {
        description()
    }
    
    private enum Const {
        enum Color {
            static let borderColor: CGColor = UIColor.systemPink.withAlphaComponent(0.2).cgColor
        }
        
        enum Layout {
            static let temperatureImageSize: CGFloat = 30
        }

        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
    }
    
    private var dataLabel = UILabel()
    private var temperatureLabel = UILabel()
    private var temperatureImage = UIImageView()
    
    private var temperatureInfoStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private var weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with model: WeatherModel.Details.ForecastDay) {
        temperatureImage.kfDownloadImage(withURL: model.day.condition.iconURL)
        temperatureLabel.createTextWithCelsiusIcon(model.day.avgtempC)
        dataLabel.text = model.date
    }
    
    private func setupLayer() {
        layer.borderWidth = Const.borderWidth
        layer.borderColor = Const.Color.borderColor
        layer.cornerRadius = Const.cornerRadius
    }
    
    private func setupLayout() {
        temperatureInfoStackView.addArrangedSubviews(temperatureImage, temperatureLabel)
        weatherStackView.addArrangedSubviews(dataLabel, temperatureInfoStackView)
        
        addSubview(weatherStackView)
        
        temperatureImage.snp.makeConstraints { make in
            make.size.equalTo(Const.Layout.temperatureImageSize)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension ForecastWeatherForThreeDaysCell: ConfigurableCell {
    static var reuseIdentifier: String {
        return identifire
    }
}
