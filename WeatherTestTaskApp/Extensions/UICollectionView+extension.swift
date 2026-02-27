//
//  UICollectionView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 27.02.2026.
//

import UIKit

protocol ConfigurableCell {
    associatedtype Model
    static var reuseIdentifier: String { get }
    func configure(with model: Model)
}

extension UICollectionView {
    func dequeueCell<T: ConfigurableCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Ячейка не создана. Возможно нужна регистрация \(T.reuseIdentifier)")
        }
        return cell
    }
}
