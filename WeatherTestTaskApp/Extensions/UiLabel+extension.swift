//
//  UiLabel+extension.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 24.02.2026.
//

import UIKit

extension UILabel {
    private enum Const {
        static let celsiusImageName: String = "degreesign.celsius"
        static let celsiusImageSize: CGSize = .init(width: 20, height: 14)
    }

    func createTextWithCelsiusIcon(_ temperature: Double, iconSize: CGSize = Const.celsiusImageSize) {
        let text = "\(temperature)"
        let attachment = NSTextAttachment()
        let imageSize = iconSize
        attachment.image = UIImage(systemName: Const.celsiusImageName)
        attachment.bounds = CGRect(origin: .zero, size: imageSize)

        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: text)
        let attributedString = NSMutableAttributedString()

        attributedString.append(textString)
        attributedString.append(attachmentString)

        attributedText = attributedString
    }
}
