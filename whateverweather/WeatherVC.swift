//
//  WeatherVC.swift
//  whateverweather
//
//  Created by Michael Dunn on 2016-09-15.
//  Copyright © 2016 Michael Dunn. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherType: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather : CurrentWeather!
    var forecast: Forecast!
    var forecasts: [Forecast] = []
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print("DEBUG LOCATION = \(Location.sharedInstance.latitude) : \(Location.sharedInstance.longitude)")
            
            currentWeather.downloadWeatherDetails {
                self.downloadForcastData {
                    // handle result and update UI
                    self.updateUI()
                    
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus() // ask user for auth or delete the app
        }
    }
    
    
    
    func downloadForcastData(completed: @escaping DownloadComplete){
        // Fetch data for forcast table
        let forcastURL = URL(string: FORECASE_WEATHER_URL)!
        Alamofire.request(
            forcastURL
            ).responseJSON { response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject>{
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>]{
                 
                        for obj in list {
                            let forecast = Forecast(weatherDict: obj)
                            self.forecasts.append(forecast)
                            //print("Forecast object \(obj)")
                        }
                        // remove first index 0 from array as it is the current day which is shown in details view
                        self.forecasts.remove(at: 0)
                        self.tableView.reloadData()
                    }
                }
                completed()
        }
        
    }
    
    
    func updateUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherType.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            
            return cell
        }
        return WeatherCell()
    }
}

