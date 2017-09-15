//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by Fernando on 6/15/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    var _highTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        
        return _currentTemp
    }
    
    
    func downloadWeatherDetails(completed: DownloadComplete){
        //Alamofire download
        
        
        Alamofire.request(CURRERNT_WEATHER_URL).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFarenheit =  Double(round(10 * (currentTemperature * (9/5) - 459.67)/10))
                        self._currentTemp = kelvinToFarenheit
                    }
                }
            }
            
        }
        completed()
    }
}
