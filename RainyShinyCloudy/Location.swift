//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by Fernando on 6/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    
    private init() { }
    
    var latitude: Double!
    var longitude: Double!
}
