//
//  WeatherUtil.swift
//  whateverweather
//
//  Created by Michael Dunn on 2016-09-18.
//  Copyright © 2016 Michael Dunn. All rights reserved.
//

import Foundation

func convertKelvinToFarenheit( kelvin: Double) -> Double {
    let temp = (kelvin * (9/5) - 459.67)
    return Double(round(10*temp/10))
}

func converKelvinToCelsius( kelvin: Double) -> Double {
    return kelvin - 273.15
}
