//
//  UIImageView+Kingfisher.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Kingfisher

extension UIImageView {
    private enum Const {
        static let defaultImageSize: Int = 64
        static let animationTime: Double = 1
    }

    func kfDownloadImage(withURL url: URL?) {
        guard let url else { return }
        
        let options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(Const.animationTime)),
            .cacheOriginalImage
        ]
        
        kf.indicatorType = .activity
        kf.setImage(with: url, options: options)
    }
}
