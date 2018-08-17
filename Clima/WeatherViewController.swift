//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import SVProgressHUD


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherData = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        onRefresh()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let weatherJSON : JSON = JSON(response.result.value!)
                    self.updateWeatherData(json: weatherJSON)
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    print("Error: \(error.localizedDescription)")
                    self.cityLabel.text = "Connections issues"
                }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        let temp = json["main"]["temp"].doubleValue
        weatherData.temperature = Int(temp - 273.15)
        weatherData.city = json["name"].stringValue
        weatherData.condition = json["weather"][0]["id"].intValue
        weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
        updateUIWithWeatherData()
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        temperatureLabel.text = "\(weatherData.temperature) ˚"
        cityLabel.text = weatherData.city
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude = \(currentLocation.coordinate.longitude)")
            print("latitude = \(currentLocation.coordinate.latitude)")
            
            let latitude = String(currentLocation.coordinate.latitude)
            let longitude = String(currentLocation.coordinate.longitude)
            let params : [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        cityLabel.text = "Location unavailable"
    }
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredNew(cityName: String) {
        SVProgressHUD.show()
        let params : [String: String] = ["q" : cityName, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationView = segue.destination as! ChangeCityViewController
            
            destinationView.delegate = self
        }
    }
    
    //MARK: - Refresh method
    /***************************************************************/
    
    func onRefresh() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        SVProgressHUD.show()
    }
    
    // refresh action button
    @IBAction func onRefreshPressed(_ sender: Any) {
        onRefresh()
    }
    
    
    
}


