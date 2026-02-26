//
//  LoaderView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit
import SnapKit

final class LoaderView: UIView {
    private enum Const {
        enum Font {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
        }
        
        enum Color {
            static let softPink: UIColor = .systemPink.withAlphaComponent(0.2)
            static let white: CGColor = UIColor.white.cgColor
        }
        
        enum Layout {
            static let heightStatic: CGFloat = 150
            static let weidthStatic: CGFloat = 200
        }
        
        static let containerCornerRadius: CGFloat = 16
        static let containerBorderWidth: CGFloat = 1
        static let containerSpacing: CGFloat = 10
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Const.Font.font
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Const.Color.softPink
        view.layer.cornerRadius = Const.containerCornerRadius
        view.layer.borderWidth = Const.containerBorderWidth
        view.layer.borderColor = Const.Color.white
        view.clipsToBounds = true
        return view
    }()
    
    private let loaderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.containerSpacing
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(containerView)
        loaderStackView.addArrangedSubviews(activityIndicator, messageLabel)
        containerView.addSubview(loaderStackView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(Const.Layout.heightStatic)
            make.width.equalTo(Const.Layout.weidthStatic)
        }
        
        loaderStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func start(with message: String = "Загрузка...") {
        messageLabel.text = message
        activityIndicator.startAnimating()
    }
    
    func stop() {
        messageLabel.text = nil
        activityIndicator.stopAnimating()
    }
}
