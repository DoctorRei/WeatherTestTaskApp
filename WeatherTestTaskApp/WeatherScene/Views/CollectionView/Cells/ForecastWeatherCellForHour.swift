//
//  ForecastWeatherCellV2.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit
import SnapKit

final class ForecastWeatherCellForHour: UICollectionViewCell {
    static var identifire: String {
        description()
    }
    
    private enum Const {
        enum Layout {
            static let temperatureImageSize: CGFloat = 50
            static let cellInset: CGFloat = 8
        }

        static let conditionStackSpacing: CGFloat = 2
    }
    
    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let temperatureImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let totalInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    func configure(with model: WeatherModel.Details.Hour) {
        timeLabel.text = model.getTime()
        temperatureLabel.createTextWithCelsiusIcon(model.tempC)
        temperatureImageView.kfDownloadImage(withURL: model.condition.iconURL)
    }
    
    private func setupLayout() {
        totalInfoStack.addArrangedSubviews(timeLabel, temperatureImageView, temperatureLabel)
        temperatureImageView.snp.makeConstraints { make in
            make.size.equalTo(Const.Layout.temperatureImageSize)
        }
        
        addSubview(totalInfoStack)
        
        totalInfoStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Const.Layout.cellInset)
        }
        
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        temperatureLabel.text = nil
        temperatureImageView.image = nil
    }
}

