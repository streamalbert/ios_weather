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
    let weather: String

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        temp = json["main"]["temp"].numberValue
        weather = json["weather"].arrayValue.first!["main"].stringValue
    }
}