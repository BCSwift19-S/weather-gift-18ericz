//
//  HourlyWeatherCell.swift
//  WeatherGift
//
//  Created by 18ericz on 3/24/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import UIKit


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ha"
    return dateFormatter
}()


class HourlyWeatherCell: UICollectionViewCell {
    @IBOutlet weak var hourlyTime: UILabel!
    @IBOutlet weak var hourlyTemp: UILabel!
    @IBOutlet weak var hourlyPrecip: UILabel!
    @IBOutlet weak var hourlyIcon: UIImageView!
    @IBOutlet weak var rainDropImage: UIImageView!
    
    func update(with hourlyForecast: WeatherDetail.HourlyForecast, timeZone: String){
        
        
            
        hourlyTemp.text = String(format: "%2.f", hourlyForecast.hourlyTemperature) + "°"
        hourlyIcon.image = UIImage(named: "small-" + hourlyForecast.hourlyIcon)
        let percipProb = hourlyForecast.hourlyPrecipProb * 100
        let isHidden = percipProb < 30.0
        hourlyPrecip.isHidden = isHidden
        rainDropImage.isHidden = isHidden
        hourlyPrecip.text = String(format: "%2.f", percipProb) + "%"
        let dateString = hourlyForecast.hourlyTime.format(timeZone: timeZone, dateFormatter: dateFormatter)
        hourlyTime.text = dateString
        
}
    
    

}
