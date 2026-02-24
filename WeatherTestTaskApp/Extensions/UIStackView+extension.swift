//
//  UIStackView+extension.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 24.02.2026.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
