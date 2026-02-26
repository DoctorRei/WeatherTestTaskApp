//
//  WeatherCollectionView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class WeatherCollectionView: UIView {
    typealias Model = WeatherModel
    
    private enum WeatherSectionTypes {
        case weatherCurrent(WeatherModel.CurrentModel)
        case weatherForThreeDays(WeatherModel.ForecastModel)
        case weatherByHour(WeatherModel.ForecastModel)
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
    
    func configure(with current: Model.CurrentModel, and forecast: Model.ForecastModel) {
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
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(
            CurrentWeatherCell.self,
            forCellWithReuseIdentifier: CurrentWeatherCell.identifire
        )
        collectionView.register(
            ForecastWeatherViewCellV2.self,
            forCellWithReuseIdentifier: ForecastWeatherViewCellV2.identifire
        )
        collectionView.register(
            WeatherForThreeDays.self,
            forCellWithReuseIdentifier: WeatherForThreeDays.identifire
        )
    }
    
    func createFlowLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, env in
            self?.getSectionFor(index: index)
        }

        return layout
    }

    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return createSection(
                itemWidth: .fractionalWidth(1),
                itemHeight: .estimated(200),
                groupWidth: .fractionalWidth(1),
                groupHeight: .estimated(200),
                sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            )
        case 1:
            return createSection(
                itemWidth: .fractionalWidth(1/3),
                itemHeight: .absolute(100),
                interItemSpacing: 10,
                groupWidth: .fractionalWidth(1),
                groupHeight: .absolute(100),
                interGroupSpacing: 10,
                sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            )
        case 2:
            return createSection(
                itemWidth: .fractionalWidth(1/5),
                itemHeight: .estimated(100),
                interItemSpacing: 10,
                groupWidth: .fractionalWidth(1),
                groupHeight: .estimated(100),
                interGroupSpacing: 10,
                sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10),
                scrollBehavior: .continuous
            )
        default:
            return createEmptySection()
        }
    }
    
    func createSection(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        interItemSpacing: Double = .zero,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        interGroupSpacing: Double = .zero,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // короче меченный. Между элементами интервал понятно. Группы мы сами указываем сколько ячеек в одной группе. Потому если не указывать интервал между группами, то вторая группа не примет значения интер итема
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        // lобавляем скролл, без него работать можно
        if let scrollBehavior {
            section.orthogonalScrollingBehavior = scrollBehavior
        }
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInsets
        
        return section
    }
    
    func createEmptySection(height: CGFloat = 0) -> NSCollectionLayoutSection {
        createSection(
            itemWidth: .fractionalWidth(1),
            itemHeight: .absolute(height),
            groupWidth: .fractionalWidth(1),
            groupHeight: .absolute(height)
        )
    }
}

extension WeatherCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var total = 0
        let sectionItem = dataSource[section]
        
        switch sectionItem {
        case .weatherCurrent:
            total += 1
        case .weatherByHour(let forecastModel):
            guard let hours = forecastModel.forecast.forecastday.first?.hour else { return total }
            total += hours.count
        case .weatherForThreeDays(let forecastModel):
            total += forecastModel.forecast.forecastday.count
        }
        
        return total
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
                withReuseIdentifier: ForecastWeatherViewCellV2.identifire,
                for: indexPath
            ) as? ForecastWeatherViewCellV2 else { return .init() }
            
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

