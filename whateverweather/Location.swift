//
//  Location.swift
//  whateverweather
//
//  Created by Michael Dunn on 2016-09-19.
//  Copyright © 2016 Michael Dunn. All rights reserved.
//

import CoreLocation



// singleton class for location
class Location{
    static var sharedInstance = Location()
    
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
