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
    
    func kfDownloadImage(withURL url: URL?, width: Int = Const.defaultImageSize, height: Int = Const.defaultImageSize) {
        guard let url else { return }
        let processor = DownsamplingImageProcessor(
            size: CGSize(width: width, height: height)
        )
        
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(Const.animationTime)),
            .cacheOriginalImage
        ]
        
        kf.indicatorType = .activity
        kf.setImage(with: url, options: options)
    }
}
