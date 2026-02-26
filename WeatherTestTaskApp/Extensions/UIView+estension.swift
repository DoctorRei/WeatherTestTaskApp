//
//  UIView+estension.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
