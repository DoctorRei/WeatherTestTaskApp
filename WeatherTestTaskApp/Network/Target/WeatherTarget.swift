//
//  WeatherTarget.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Moya
import Alamofire

enum WeatherTarget {
    typealias Coordinate = LocationModel.Coordinate

    case current(coordinate: Coordinate)
    case forecast3Days(coordinate: Coordinate)
}

extension WeatherTarget: TargetType {
    private enum Const {
        static let basePath: String = "https://api.weatherapi.com/v1"
        static let current: String = "/current.json"
        static let forecast3Days: String = "/forecast.json"
        static let APIKey: String = "fa8b3df74d4042b9aa7135114252304"
        static let threeDaysCount: String = "3"
        static let header: [String: String] = ["Content-type": "application/json"]
    }
    
    var baseURL: URL {
        return URL(string: Const.basePath)!
    }

    var path: String {
        switch self {
        case .current:
            return Const.current
        case .forecast3Days:
            return Const.forecast3Days
        }
    }

    var method: Moya.Method {
        switch self {
        case .current, .forecast3Days:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .current(let coordinate):
            return .requestParameters(
                parameters: [
                    "key": Const.APIKey,
                    "q": "\(coordinate.latitude),\(coordinate.longitude)"
                ],
                encoding: URLEncoding.default
            )
        case .forecast3Days(let coordinate):
            return .requestParameters(
                parameters: [
                    "key": Const.APIKey,
                    "q": "\(coordinate.latitude),\(coordinate.longitude)",
                    "days": Const.threeDaysCount
                ],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        Const.header
    }
}
