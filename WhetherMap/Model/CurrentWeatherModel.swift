//
//  CurrentWeatherModel.swift
//  WhetherMap
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation

struct CurrentWeatherModel {
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return "\(temperature.rounded())°C"
    }
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return "Feels like \(feelsLikeTemperature.rounded())°C"
    }
    let conditionCode: Int
    var iconCode: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fil"
        case 300...321: return "cloud.drizzle.fill"
        case 500...521: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    
    init?(currentWeatherData: CurrentWetherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
