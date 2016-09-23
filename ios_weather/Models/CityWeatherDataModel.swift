//
//  CityWeatherDataModel.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityWeatherDataModel {

    let id: NSNumber
    let name: String
    let temp: NSNumber
    let tempMin: NSNumber
    let tempMax: NSNumber
    let weather: String
    let weatherIcon: String

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        temp = json["main"]["temp"].numberValue
        tempMin = json["main"]["temp_min"].numberValue
        tempMax = json["main"]["temp_max"].numberValue
        weather = json["weather"].arrayValue.first!["main"].stringValue
        weatherIcon = json["weather"].arrayValue.first!["icon"].stringValue
    }
}