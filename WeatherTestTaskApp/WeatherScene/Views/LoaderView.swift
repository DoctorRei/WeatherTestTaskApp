//
//  LoaderView.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 26.02.2026.
//

import UIKit
import SnapKit

protocol LoaderViewDelegate: AnyObject {
    func buttonTap()
}

final class LoaderView: UIView {
    private enum Const {
        enum Font {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
        }
        enum Color {
            static let softPink: UIColor = .systemPink.withAlphaComponent(0.2)
            static let white: CGColor = UIColor.white.cgColor
            static let red: CGColor = UIColor.red.withAlphaComponent(0.2).cgColor
        }
        enum Layout {
            static let heightStatic: CGFloat = 150
            static let weidthStatic: CGFloat = 200
        }
        enum Text {
            static let loading: String = "Loading..."
            static let error: String = "Error. Try Again"
            static let refresh: String = "Refresh"
        }

        static let containerCornerRadius: CGFloat = 16
        static let containerBorderWidth: CGFloat = 1
        static let containerSpacing: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 8
        static let buttonInsets: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
    }

    weak var delegate: LoaderViewDelegate?

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
        return view
    }()

    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.Text.refresh, for: .normal)
        button.backgroundColor = Const.Color.softPink
        button.layer.borderWidth = Const.containerBorderWidth
        button.layer.borderColor = Const.Color.white
        button.layer.cornerRadius = Const.buttonCornerRadius
        button.contentEdgeInsets = Const.buttonInsets
        button.isHidden = true
        button.addTarget(self, action: #selector(refreshButtonTap), for: .touchUpInside)
        return button
    }()

    private let loaderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
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

    func showError() {
        isNeedToShowError(with: true)
        setupLabelText(with: Const.Text.error)
    }

    func start() {
        isNeedToShowError(with: false)
        setupLabelText(with: Const.Text.loading)
        activityIndicator.startAnimating()
    }

    func stop() {
        setupLabelText(with: nil)
        activityIndicator.stopAnimating()
    }

    @objc private func refreshButtonTap() {
        start()
        delegate?.buttonTap()
    }

    private func setupLabelText(with text: String?) {
        messageLabel.text = text
    }

    private func isNeedToShowError(with value: Bool) {
        activityIndicator.isHidden = value
        refreshButton.isHidden = !value
        containerView.layer.borderColor = value ? Const.Color.red : Const.Color.white
    }

    private func setupUI() {
        addSubviews(containerView)
        loaderStackView.addArrangedSubviews(activityIndicator, messageLabel, refreshButton)
        containerView.addSubview(loaderStackView)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(Const.Layout.heightStatic)
            make.width.equalTo(Const.Layout.weidthStatic)
        }

        loaderStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
