//
//  CurrentWetherData.swift
//  WhetherMap
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation

struct CurrentWetherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike : Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
