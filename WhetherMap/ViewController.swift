//
//  ViewController.swift
//  WhetherMap
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var cityLable: UILabel!
    @IBAction func searheCity(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { city in
            self.network.fetchCuttentWeather(forRequestType: .cityName(city: city))
        }
        
    }
    
    @IBOutlet weak var celsiumLable: UILabel!
    @IBOutlet weak var feltCelsium: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    
    var network = NetworkWether()
    
   lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    
    }
    

}


extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, complitionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                //self.network.fetchCuttentWeather(forCity: cityName)
                let city = cityName.split(separator: " ").joined(separator: "%20")
                complitionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension ViewController: NetworkWetherDelegate {
    func updateInterface(_: NetworkWether, with currentWeather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.cityLable.text? = currentWeather.cityName
            self.celsiumLable.text = currentWeather.temperatureString
            self.feltCelsium.text = currentWeather.feelsLikeTemperatureString
            self.iconImage.image = UIImage(systemName: currentWeather.iconCode)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longtude = location.coordinate.longitude
        
        network.fetchCuttentWeather(forRequestType: .coordinate(latitude: latitude, longtude: longtude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription )
    }
}
