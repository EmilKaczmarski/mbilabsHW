//
//  DailyWeather.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 07/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

// MARK: - DailyWeather
struct DailyWeather: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
    let city: City
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: WeatherParams
    let weather: [WeatherDescription]
    let clouds: Clouds
    let wind: Wind
//    let snow: Snow
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct WeatherParams: Codable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
