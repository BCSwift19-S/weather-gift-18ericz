//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by 18ericz on 3/17/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    
    struct HourlyForecast {
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    
    struct DailyForcast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
    }
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailylForecastArray = [DailyForcast]()
    var hourlyForecastArray = [HourlyForecast]()
    
    
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON{  response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            if let temperature = json["currently"]["temperature"].double {
                let roundTemp = String(format: "%3.f", temperature)
                self.currentTemp = roundTemp + "°"
            } else{
                print("Could not return Temperature")
            }
            if let summary = json["daily"]["summary"].string {
                self.currentSummary = summary
            } else{
                print("Could not return Summary")
            }
            if let icon = json["currently"]["icon"].string {
                self.currentIcon = icon
            } else{
                print("Could not return Icon")
            }
            if let timeZone = json["timezone"].string {
                print("Time for \(self.name) is \(timeZone)")
                self.timeZone = timeZone
            } else{
                print("Could not return Time Zone")
            }
            if let time = json["currently"]["time"].double {
                print("Time for \(self.name) is \(time)")
                self.currentTime = time
            } else{
                print("Could not return time")
            }
            
            let dailyDataArray = json["daily"]["data"]
            self.dailylForecastArray = []
            let days = min(7, dailyDataArray.count-1)
            for day in 1...days{
                let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                let dateValue = json["daily"]["data"][day]["time"].doubleValue
                let icon = json["daily"]["data"][day]["icon"].stringValue
                let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                let newDailyForecast = DailyForcast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                self.dailylForecastArray.append(newDailyForecast)
            }
            
            let hourlyDataArray = json["hourly"]["data"]
            self.hourlyForecastArray = []
            let hours = min(24,hourlyDataArray.count-1)
            for hour in 1...hours{
                let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                let hourlyPrecipProb = json["hourly"]["data"][hour]["precipProbability"].doubleValue
                let hourlyIcon = json["hourly"]["data"][hour]["icon"].stringValue
                let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime
                    , hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon)
                self.hourlyForecastArray.append(newHourlyForecast)
            }

        case .failure(let error):
            print(error)
        }
        completed()
        }
    }
}
