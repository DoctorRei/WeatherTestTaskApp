//
//  WeatherBy3Days.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class WeatherForThreeDays: UICollectionViewCell {
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
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with model: WeatherModel.Details.ForecastDay) {
        temperatureImage.kfDownloadImage(withURL: model.day.condition.iconURL)
        temperatureLabel.createTextWithCelsiusIcon(model.day.avgtempC)
        dataLabel.text = model.date
    }
    
    private func setupLayout() {
        temperatureInfoStackView.addArrangedSubviews(temperatureImage, temperatureLabel)
        weatherStackView.addArrangedSubviews(dataLabel, temperatureInfoStackView)
        
        addSubview(weatherStackView)
        
        weatherStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
