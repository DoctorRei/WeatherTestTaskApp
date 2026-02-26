//
//  CurrentWeatherView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit
import SnapKit

final class CurrentWeatherCell: UICollectionViewCell {
    static var identifire: String {
        description()
    }
    
    private enum Const {
        enum Color {
            static let borderColor: CGColor = UIColor.systemPink.withAlphaComponent(0.2).cgColor
        }
        static let cityLabelFontSize: CGFloat = 18
        static let countryLabelFontSize: CGFloat = 16
        static let temperatureLabelFontSize: CGFloat = 40
        
        static let locationStackSpacing: CGFloat = 2
        static let temperatureStackSpacing: CGFloat = 4
        static let currentWeatherStackInset: CGFloat = 8
        
        static let celsiusImageSize: CGSize = .init(width: 30, height: 24)
        static let temperatureImageSize: CGFloat = 40
        
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        setupLayer()
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
    
    private func setupLayer() {
        layer.borderWidth = Const.borderWidth
        layer.borderColor = Const.Color.borderColor
        layer.cornerRadius = Const.cornerRadius
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
    
    override func prepareForReuse() {
        cityLabel.text = nil
        countryLabel.text = nil
        tempertureLabel.text = nil
        temperatureImage.image = nil
    }
}
