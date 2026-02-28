//
//  WeatherSections.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit

enum WeatherSection: Int, CaseIterable {
    case current
    case threeDays
    case hourly

    func createLayout() -> NSCollectionLayoutSection {
        switch self {
        case .current:
            return createSection(with: LayoutModels.currentModel)
        case .threeDays:
            return createSection(with: LayoutModels.threeDaysModel)
        case .hourly:
            return createSection(with: LayoutModels.hourlyModel)
        }
    }
}


private extension WeatherSection {
    func createSection(with model: LayoutModel) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: model.itemWidth, heightDimension: model.itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: model.groupWidth, heightDimension: model.groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.interItemSpacing = .fixed(model.itemSpacing)

        let section = NSCollectionLayoutSection(group: group)

        if let scrollBehavior = model.scrollBehavior {
            section.orthogonalScrollingBehavior = scrollBehavior
        }

        section.interGroupSpacing = model.groupSpacing
        section.contentInsets = model.sectionInsets

        return section
    }
}
