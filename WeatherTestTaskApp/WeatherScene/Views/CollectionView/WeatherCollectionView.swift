//
//  WeatherCollectionView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class WeatherCollectionView: UIView {
    typealias CurrentModel = WeatherModel.CurrentModel
    typealias ForecastModel = WeatherModel.ForecastModel
    
    private enum WeatherSectionTypes {
        case weatherCurrent(CurrentModel)
        case weatherForThreeDays(ForecastModel)
        case weatherByHour(ForecastModel)
    }
    
    private var dataSource: [WeatherSectionTypes] = []
    
    private var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with current: CurrentModel, and forecast: ForecastModel) {
        let currentType = WeatherSectionTypes.weatherCurrent(current)
        let forecastType = WeatherSectionTypes.weatherByHour(forecast)
        let forecastForThreeDays = WeatherSectionTypes.weatherForThreeDays(forecast)
        
        dataSource.append(currentType)
        if forecast.forecast.forecastday.count > 1 {
            dataSource.append(forecastForThreeDays)
        }
        dataSource.append(forecastType)
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(createFlowLayout(), animated: false)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(
            CurrentWeatherCell.self,
            forCellWithReuseIdentifier: CurrentWeatherCell.identifire
        )
        collectionView.register(
            ForecastWeatherCellForHour.self,
            forCellWithReuseIdentifier: ForecastWeatherCellForHour.identifire
        )
        collectionView.register(
            WeatherForThreeDays.self,
            forCellWithReuseIdentifier: WeatherForThreeDays.identifire
        )
    }
    
    func createFlowLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { index, env in
            guard let section = WeatherSection(rawValue: index) else { return nil }
            
            return section.createLayout()
        }
        return layout
    }
}

extension WeatherCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sectionsCount = 0
        let sectionItem = dataSource[section]
        
        switch sectionItem {
        case .weatherCurrent:
            sectionsCount += 1
        case .weatherByHour(let forecastModel):
            guard let hours = forecastModel.forecast.forecastday.first?.hour else { return sectionsCount }
            sectionsCount += hours.count
        case .weatherForThreeDays(let forecastModel):
            sectionsCount += forecastModel.forecast.forecastday.count
        }
        
        return sectionsCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let sectionItem = dataSource[indexPath.section]
        
        switch sectionItem {
        case .weatherCurrent(let model):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrentWeatherCell.identifire,
                for: indexPath
            ) as? CurrentWeatherCell else { return .init() }
            
            cell.configure(with: model)
            
            return cell
        case .weatherByHour(let model):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ForecastWeatherCellForHour.identifire,
                for: indexPath
            ) as? ForecastWeatherCellForHour else { return .init() }
            
            if let hour = model.forecast.forecastday.first?.hour[indexPath.item] {
                cell.configure(with: hour)
            }
            
            return cell
            
        case .weatherForThreeDays(let model):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WeatherForThreeDays.identifire,
                for: indexPath
            ) as? WeatherForThreeDays else { return .init() }
            
            cell.configure(with: model.forecast.forecastday[indexPath.item])
            
            return cell
        }
    }
}

