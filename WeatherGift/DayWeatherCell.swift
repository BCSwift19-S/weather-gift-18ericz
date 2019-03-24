//
//  DayWeatherCell.swift
//  WeatherGift
//
//  Created by 18ericz on 3/24/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMD dd, y"
    return dateFormatter
}()

class DayWeatherCell: UITableViewCell {
    @IBOutlet weak var dayCellIcon: UIImageView!
    @IBOutlet weak var dayCellWeekDay: UILabel!
    @IBOutlet weak var dayCellMaxTemp: UILabel!
    @IBOutlet weak var dayCellMinTemp: UILabel!
    @IBOutlet weak var dayCellSummary: UITextView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with dailyForecast: WeatherLocation.DailyForcast, timeZone: String){
        dayCellIcon.image = UIImage(named: dailyForecast.dailyIcon)
        dayCellSummary.text = dailyForecast.dailySummary
        dayCellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp)
        dayCellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp)
        

        let dateString = dailyForecast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
        dayCellWeekDay.text = dateString
    }

}
