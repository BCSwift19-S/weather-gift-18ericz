//
//  DetailVC.swift
//  WeatherGift
//
//  Created by 18ericz on 3/9/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
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
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        temperatureLabel.text = locationsArray[currentPage].currentTemp
        summaryLabel.text = locationsArray[currentPage].currentSummary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
        print("%%%%% Current Temperature inside UpdateUserInterface = \(locationsArray[currentPage].currentTemp)")
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
                self.locationsArray[0].getWeather {
                    self.updateUserInterface()
                }
                
        })
    }

}
