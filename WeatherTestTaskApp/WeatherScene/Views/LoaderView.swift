//
//  LoaderView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit
import SnapKit

final class LoaderView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let loaderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
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
        addSubviews(backgroundView, containerView)
        loaderStackView.addArrangedSubviews(activityIndicator, messageLabel)
        containerView.addSubview(loaderStackView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(200)
        }
    }
    
    // MARK: - Public Methods
    func start(with message: String = "Загрузка...") {
        messageLabel.text = message
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
}
