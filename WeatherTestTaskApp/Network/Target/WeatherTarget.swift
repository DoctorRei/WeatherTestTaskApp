//
//  WeatherTarget.swift
//  WeatherTestTaskApp
//
//  Created by Akira Rei on 23.02.2026.
//

import Moya
import Alamofire

enum WeatherTarget {
    case current
    case forecast3Days
}

extension WeatherTarget: TargetType {
    private enum Const {
        static let basePath: String = "https://api.weatherapi.com/v1"
        static let current: String = "/current.json"
        static let forecast3Days: String = "/forecast.json"
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
        case .forecast3Days:
            return .requestParameters(
                parameters: [
                    "key": "fa8b3df74d4042b9aa7135114252304",
                    "q": "LAT,LON",
                    "days": "3"
                ],
                encoding: URLEncoding.default
            )
        case .current:
            return .requestParameters(
                parameters: [
                    "key": "fa8b3df74d4042b9aa7135114252304",
                    "q": "LAT,LON"
                ],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
