//
//  NetworkWether.swift
//  WhetherMap
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation
import CoreLocation

protocol NetworkWetherDelegate {
    func updateInterface(_: NetworkWether, with currentWeather: CurrentWeatherModel)
}

class NetworkWether {
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longtude: CLLocationDegrees)
    }
    
    private let key = "bdc4061e3511e9f9cc8ed42eec8c353a"
    var delegate: NetworkWetherDelegate?
    
    
    
    func fetchCuttentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)&units=metric"
        case .coordinate(let latitude, let longtude): urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtude)&appid=\(key)&units=metric"
        }
        
        performRequest(withUrlString: urlString)
    }
 
    
   fileprivate func performRequest(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.delegate?.updateInterface(self, with: currentWeather )
                }
            }
        }
        task.resume()
    }
    
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let currentWhetherData = try decoder.decode(CurrentWetherData.self, from: data)
            guard let currentWeather = CurrentWeatherModel(currentWeatherData: currentWhetherData) else { return nil}
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
