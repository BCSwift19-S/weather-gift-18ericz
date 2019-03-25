//
//  DetailVC.swift
//  WeatherGift
//
//  Created by 18ericz on 3/9/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMD dd, y"
    return dateFormatter
}()

class DetailVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationDetail: WeatherDetail!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        locationDetail = WeatherDetail(name: locationsArray[currentPage].name, coordinates: locationsArray[currentPage].coordinates)
        if currentPage != 0 {
            self.locationDetail.getWeather {
                self.updateUserInterface()
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }
    

    func updateUserInterface(){
        let location = locationDetail
        locationLabel.text = location!.name
        let dateString = locationDetail.currentTime.format(timeZone: locationDetail.timeZone, dateFormatter: dateFormatter)
        dateLabel.text = dateString
        temperatureLabel.text = locationDetail.currentTemp
        summaryLabel.text = locationDetail.currentSummary
        currentImage.image = UIImage(named: locationDetail.currentIcon)
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension DetailVC: CLLocationManagerDelegate{
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        
    }
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case.denied:
            print("I AM SORRY CANT SHOW LOCATION")
        case.restricted:
            print("Access denied")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        dateLabel.text = currentCoordinates
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
            {placemarks, error in
                if placemarks != nil{
                    let placemark = placemarks?.last
                    place = (placemark?.name)!
                } else{
                    print("Error \(error)")
                    place = "unknown"
                }
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentCoordinates
                self.locationDetail = WeatherDetail(name: place, coordinates: currentCoordinates)
                self.locationDetail.getWeather {
                    self.updateUserInterface()
                }
                
        })
    }

}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDetail.dailylForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        let dailyForecast = locationDetail.dailylForecastArray[indexPath.row]
        let timeZone = locationDetail.timeZone
        cell.update(with: dailyForecast, timeZone: timeZone)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationDetail.hourlyForecastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCell
        let hourlyForecast = locationDetail.hourlyForecastArray[indexPath.row]
        let timeZone = locationDetail.timeZone
        hourlyCell.update(with: hourlyForecast, timeZone: timeZone)
        return hourlyCell
    }
    
    
}
