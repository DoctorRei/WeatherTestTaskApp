//
//  WeatherSectionModels.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit

extension WeatherSection {
    enum LayoutModels {
        static let currentModel: LayoutModel = .init(
            itemWidth: .fractionalWidth(1),
            itemHeight: .estimated(200),
            groupWidth: .fractionalWidth(1),
            groupHeight: .estimated(200),
            sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        )
        static let threeDaysModel: LayoutModel = .init(
            itemWidth: .fractionalWidth(1/3),
            itemHeight: .absolute(100),
            itemSpacing: 10,
            groupWidth: .fractionalWidth(1),
            groupHeight: .absolute(100),
            groupSpacing: 10,
            sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        )
        static let hourlyModel: LayoutModel = .init(
            itemWidth: .fractionalWidth(1/5),
            itemHeight: .estimated(100),
            itemSpacing: 10,
            groupWidth: .fractionalWidth(1),
            groupHeight: .estimated(100),
            groupSpacing: 10,
            sectionInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10),
            scrollBehavior: .continuous
        )
    }
    
    struct LayoutModel {
        let itemWidth: NSCollectionLayoutDimension
        let itemHeight: NSCollectionLayoutDimension
        let itemSpacing: Double
        let groupWidth: NSCollectionLayoutDimension
        let groupHeight: NSCollectionLayoutDimension
        let groupSpacing: Double
        let sectionInsets: NSDirectionalEdgeInsets
        let scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior?

        init(
            itemWidth: NSCollectionLayoutDimension,
            itemHeight: NSCollectionLayoutDimension,
            itemSpacing: Double = .zero,
            groupWidth: NSCollectionLayoutDimension,
            groupHeight: NSCollectionLayoutDimension,
            groupSpacing: Double = .zero,
            sectionInsets: NSDirectionalEdgeInsets = .zero,
            scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil
        ) {
            self.itemWidth = itemWidth
            self.itemHeight = itemHeight
            self.itemSpacing = itemSpacing
            self.groupWidth = groupWidth
            self.groupHeight = groupHeight
            self.groupSpacing = groupSpacing
            self.sectionInsets = sectionInsets
            self.scrollBehavior = scrollBehavior
        }
    }
}
