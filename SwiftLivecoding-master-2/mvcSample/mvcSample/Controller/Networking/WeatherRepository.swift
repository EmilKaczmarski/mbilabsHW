//
//  WeatherRepository.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 26/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case weatherForCity(String)
    case dailyWeather(String)

    private var basePath: String {
        return "https://api.openweathermap.org/data/2.5"
    }

    var path: String {
        return basePath + endpoint
    }

    var url: URL? {
        return URL(string: path)
    }

    var endpoint: String {
        switch self {
        case .weatherForCity:
            return "/weather"
        case .dailyWeather:
            return "/forecast"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var queryParams: Parameters {
        var params = ["appid": "8ff1fb3e2647bfd32f6ac1aa277253f7",
                      "units": "metric"]
        switch self {
        case .weatherForCity(let city):
            params["q"] = city
        case .dailyWeather(let city):
            params["q"] = city
        }

        return params
    }
}

struct WeatherRepository {
    static func getCurrentWeather(_ cityName: String, completion: @escaping ((Weather?, Error?) -> Void)) {
        execureRequest(.weatherForCity(cityName), completion: completion)
    }

    static func get5DaysForecast(for cityName: String, completion: @escaping ((DailyWeather?, Error?) -> Void)) {
        execureRequest(.dailyWeather(cityName), completion: completion)
    }

    private static func execureRequest<T: Codable>(_ request: WeatherAPI,
                                                   completion: @escaping ((T?, Error?) -> Void)) {
        guard let requestUrl = request.url else { return }

        AF
            .request(requestUrl,
                     method: request.method,
                     parameters: request.queryParams)
            .response { response in
                guard let data = response.data else { return }

                do {
                    let decoder = JSONDecoder()
                    let responseObject: T = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
        }
    }
}
