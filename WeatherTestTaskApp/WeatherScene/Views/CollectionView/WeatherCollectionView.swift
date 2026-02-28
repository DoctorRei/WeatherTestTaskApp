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
    
    func configure(with current: CurrentModel, and forecast: ForecastModel) {
        let currentType = WeatherSectionTypes.weatherCurrent(current)
        let forecastType = WeatherSectionTypes.weatherByHour(forecast)
        let forecastForThreeDays = WeatherSectionTypes.weatherForThreeDays(forecast)
        
        dataSource.append(currentType)
        dataSource.append(forecastForThreeDays)
        dataSource.append(forecastType)
        
        collectionView.reloadData()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            ForecastWeatherForHourCell.self,
            forCellWithReuseIdentifier: ForecastWeatherForHourCell.identifire
        )
        collectionView.register(
            ForecastWeatherForThreeDaysCell.self,
            forCellWithReuseIdentifier: ForecastWeatherForThreeDaysCell.identifire
        )
    }
    
    private func createFlowLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { index, env in
            guard let section = WeatherSection(rawValue: index) else { return nil }
            
            return section.createLayout()
        }
        return layout
    }
}

// MARK: - UICollectionView Delegate && DataSource
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
            let hours = forecastModel.filterHours()
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
            let cell: CurrentWeatherCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model)
            return cell

        case .weatherByHour(let model):
            let cell: ForecastWeatherForHourCell = collectionView.dequeueCell(for: indexPath)
            let hours = model.filterHours()
            cell.configure(with: hours[indexPath.item])
            return cell

        case .weatherForThreeDays(let model):
            let cell: ForecastWeatherForThreeDaysCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(with: model.forecast.forecastday[indexPath.item])
            return cell
        }
    }
}

