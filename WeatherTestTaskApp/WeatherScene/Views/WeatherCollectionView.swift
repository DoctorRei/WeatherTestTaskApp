//
//  WeatherCollectionView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class WeatherCollectionView: UIView {
    private enum WeatherSectionTypes {
        case weatherCurrent(WeatherModel.CurrentModel)
        case weatherByHour(WeatherModel.ForecastModel)
        case weather3Days(WeatherModel.ForecastModel)
    }
    
//    private var sectionDataSource: [[UIColor]] = {
//        let firstColors: [UIColor] = [.yellow, .yellow, .yellow]
//        let seccondColors: [UIColor] = [.systemBlue, .systemBlue, .systemBlue, .systemBlue]
//        let thirdColors: [UIColor] = [.systemGreen, .systemGreen, .systemGreen, .systemGreen, .systemGreen]
//        
//        return [firstColors, seccondColors, thirdColors]
//    }()
    
    private var sectionDataSource: [[WeatherSectionTypes]] = []
    
    private var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collection.backgroundColor = .red
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
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(createFlowLayout(), animated: false)
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(
            ForecastWeatherViewCell.self,
            forCellWithReuseIdentifier: ForecastWeatherViewCell.identifire
        )
        collectionView.register(
            HeaderViewCell.self,
            forSupplementaryViewOfKind: HeaderViewCell.identifire,
            withReuseIdentifier: HeaderViewCell.identifire
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
                itemHeight: .absolute(200),
                groupWidth: .fractionalWidth(1),
                groupHeight: .absolute(200),
                scrollBehavior: .groupPagingCentered
            )
        case 1:
            return createSection(
                itemWidth: .fractionalWidth(1/3),
                itemHeight: .absolute(100),
                interItemSpacing: 10,
                groupWidth: .fractionalWidth(1),
                groupHeight: .absolute(100),
                interGroupSpacing: 10,
                sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10),
                headerHeight: .absolute(50),
                scrollBehavior: .continuous
            )
        case 2:
            return createSection(
                itemWidth: .fractionalWidth(1/3),
                itemHeight: .absolute(100),
                interItemSpacing: 10,
                groupWidth: .fractionalWidth(1),
                groupHeight: .absolute(100),
                interGroupSpacing: 10,
                sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            )
        default:
            break
        }
        
        return createEmptySection()
    }
    
    func createSection(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        interItemSpacing: Double = .zero,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        interGroupSpacing: Double = .zero,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        headerHeight: NSCollectionLayoutDimension? = nil,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // короче меченный. Между элементами интервал понятно. Группы мы сами указываем сколько ячеек в одной группе. Потому если не указывать интервал между группами, то вторая группа не примет значения интер итема
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        // lобавляем скролл, без него работать можно
        section.orthogonalScrollingBehavior = scrollBehavior
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInsets
        
        section.boundarySupplementaryItems = []
        if let headerHeight {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: headerHeight)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HeaderViewCell.self.description(),
                alignment: .top
            )
            
            section.boundarySupplementaryItems.append(header)
        }
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionDataSource[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionDataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherViewCell.identifire, for: indexPath) as? ForecastWeatherViewCell else { return .init() }
        
        cell.backgroundColor = sectionDataSource[indexPath.section][indexPath.item]
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == HeaderViewCell.self.description() {
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderViewCell.self.description(),
                for: indexPath
            ) as? HeaderViewCell else {
                return .init()
            }
            cell.backgroundColor = .gray
            return cell
        }

        return UICollectionReusableView()
    }
    
}

