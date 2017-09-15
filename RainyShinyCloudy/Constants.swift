//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by Fernando on 6/15/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "c9191934d188f431a384cf92d6e60dac"

typealias DownloadComplete = () -> ()

let CURRERNT_WEATHER_URL = "\(BASE_URL)weather?\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

let FORECAST_URL = "\(BASE_URL)forecast/daily?\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"
