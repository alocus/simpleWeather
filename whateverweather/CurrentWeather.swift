//
//  CurrentWeather.swift
//  whateverweather
//
//  Created by Michael Dunn on 2016-09-16.
//  Copyright © 2016 Michael Dunn. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather{
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    private var _minTemp: Double!
    private var _maxTemp: Double!
    
    
    var cityName: String{
        print("DEBUG: cityName is \(_cityName)")
        return (_cityName != nil) ? _cityName : "NN"
    }
    
    var date: String{
        print("DEBUG: The date is \(_date)")
        _date = (_date != nil) ? _date : "NN"
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType: String{
        return (_weatherType != nil) ? _weatherType : ""
    }
    
    var currentTemp: Double{
        return (_currentTemp != nil) ? converKelvinToCelsius(kelvin: _currentTemp) : 0.0
    }
    
    //var currentTemp: Double{
    //    if _currentTemp == nil {
    //        _currentTemp = 0.0
    //    }
    //    return _currentTemp
    //}
    
    func downloadWeatherDetails (completed: @escaping DownloadComplete){
        // Alamofire download
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        Alamofire.request(
            currentWeatherURL
            )
            .responseJSON { response in
                let result = response.result
                print(response)
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let name = dict["name"] as? String {
                        self._cityName = name.capitalized
                        print("DEBUG \(self._cityName)")
                    }
                    
                    if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                        if let weatherType = weather[0]["main"] as? String {
                                self._weatherType = weatherType.capitalized
                            print("DEBUG \(self._weatherType)")
                        }
                    }
                    
                    if let main = dict["main"] as? Dictionary<String, AnyObject> {
                        if let currentTemp = main["temp"] as? Double {
                            self._currentTemp = currentTemp
                            print( self._currentTemp)
                        }
                        if let tempMin = main["temp_min"] as? Double {
                            self._minTemp = tempMin
                        }
                        if let tempMax = main["temp_max"] as? Double {
                            self._maxTemp = tempMax
                        }
                        
                    }
                    
                }
                completed()
            } // responseJSON
    }
}
