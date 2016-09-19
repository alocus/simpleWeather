//
//  Constants.swift
//  whateverweather
//
//  Created by Michael Dunn on 2016-09-16.
//  Copyright © 2016 Michael Dunn. All rights reserved.
//

import Foundation


let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let FORECASE_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?cnt=10&mode=json&"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "" 

let COMMON_URL_PARMS = "\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(COMMON_URL_PARMS)"

let FORECASE_WEATHER_URL = "\(FORECASE_BASE_URL)\(COMMON_URL_PARMS)"
