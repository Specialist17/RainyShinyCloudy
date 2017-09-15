//
//  ViewController.swift
//  RainyShinyCloudy
//
//  Created by Fernando on 5/22/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var currentWeatherTypeLbl: UILabel!
    
    @IBOutlet weak var weatherTable: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    var delayInSeconds = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        weatherTable.delegate = self
        weatherTable.dataSource = self
        
        
        
        currentWeather = CurrentWeather()

        
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus () {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                    self.downloadForecastData {
                        self.upadateMainUI()
                    }
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete){
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>]{
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        
                        self.forecasts.append(forecast)

                    }
                    self.forecasts.remove(at: 0)
                    self.weatherTable.reloadData()
                }
            }
            completed()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = weatherTable.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    
    func upadateMainUI() {
        dateLbl.text = currentWeather.date
        currentTempLbl.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLbl.text = currentWeather.weatherType
        locationLbl.text = currentWeather.cityName
        currentWeatherImg.image = UIImage(named: currentWeather.weatherType)
        
        print("Date: \(currentWeather.date)")
        print("temp: \(currentWeather.currentTemp)")
        print("Weather type: \(currentWeather.weatherType)")
        print("City: \(currentWeather.cityName)")
        
    }

}

