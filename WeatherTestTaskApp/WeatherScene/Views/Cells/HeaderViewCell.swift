//
//  HeaderViewCell.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 25.02.2026.
//

import UIKit
import SnapKit

final class HeaderViewCell: UICollectionReusableView {
    static var identifire: String {
        description()
    }
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with text: String) {
        infoLabel.text = text
    }
    
    private func setupLayout() {
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    override func prepareForReuse() {
        infoLabel.text = nil
    }
}
