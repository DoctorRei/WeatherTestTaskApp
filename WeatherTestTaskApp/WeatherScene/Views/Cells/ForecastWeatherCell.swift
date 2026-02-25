//
//  ForecastWeatherView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 24.02.2026.
//

import UIKit
import SnapKit

final class ForecastWeatherViewCell: UICollectionViewCell {
    static var identifire: String {
        description()
    }
    
    private enum Const {
        static let conditionStackSpacing: CGFloat = 2
        static let temperatureImageSize: CGFloat = 40
        static let cellInset: CGFloat = 8
    }
    
    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let temperatureImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let conditionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Const.conditionStackSpacing
        return stackView
    }()
    private let totalInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    func configure(with model: WeatherModel.Details.Hour) {
        timeLabel.text = model.getTime()
        temperatureLabel.createTextWithCelsiusIcon(model.tempC)
        conditionLabel.text = model.condition.text
        temperatureImageView.kfDownloadImage(withURL: model.condition.iconURL)
    }
    
    private func setupLayout() {
        conditionStack.addArrangedSubviews(temperatureImageView, conditionLabel)
        totalInfoStack.addArrangedSubviews(timeLabel, temperatureLabel, conditionStack)
        temperatureImageView.snp.makeConstraints { make in
            make.size.equalTo(Const.temperatureImageSize)
        }
        
        addSubview(totalInfoStack)
        
        totalInfoStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Const.cellInset)
        }
        
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        temperatureLabel.text = nil
        conditionLabel.text = nil
        temperatureImageView.image = nil
    }
}
