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
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
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
        case .failure(let error):
            print(error)
        }
        completed()
        }
    }
}
