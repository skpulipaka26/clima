//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    
    //TODO: Declare instance variables here
    var locationManager = CLLocationManager()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(_ url: String, _ params: [String: String]){
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(weatherJSON: weatherJSON)
            } else {
                self.cityLabel.text = "connection issues - try again"
            }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(weatherJSON: JSON) {
        if let tempResult = weatherJSON["main"]["temp"].double {
            let city: String = weatherJSON["name"].stringValue
            let condition: Int = weatherJSON["weather"][0]["id"].intValue
            let weatherData = WeatherDataModel(Int(tempResult - 273.15), condition, city)
            updateUI(weatherData: weatherData)
        } else {
            cityLabel.text = "wether unavailable - try again"
        }
    }
    
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUI(weatherData: WeatherDataModel) {
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(String(weatherData.temperature ?? 0))°"
        weatherIcon.image = UIImage(named: weatherData.updateWeatherIcon(condition: weatherData.condition ?? 0))
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        if location.horizontalAccuracy > 0 {
            
            // stop the location manager once the coordinates are received
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude: CLLocationDegrees = location.coordinate.latitude
            let longitude: CLLocationDegrees = location.coordinate.longitude
            
            
            let params : [String: String] = ["lat": String(latitude), "lon": String(longitude), "appid": APP_ID]
            
            // make a http request using Alamofire
            getWeatherData(WEATHER_URL, params)
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unvailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    
    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


