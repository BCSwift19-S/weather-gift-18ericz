//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by 18ericz on 3/24/19.
//  Copyright © 2019 18ericz. All rights reserved.
//

import Foundation

class WeatherLocation {
    var name = ""
    var coordinates = ""
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}
