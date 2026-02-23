//
//  MainCoordinator.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import UIKit

final class MainCoordinator: NSObject {
    private weak var window: UIWindow?
    private let navigation = UINavigationController()
    
    //MARK: - Main
    func start(with window: UIWindow?) {
        self.window = window
        window?.rootViewController = navigation
        let weatherAssembly = WeatherAssembly()
        let weatherVC = weatherAssembly.configure()

        navigation.pushViewController(weatherVC, animated: true)
    }
}
