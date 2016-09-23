//
//  DataServiceManager.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let OpenWeatherAPIKey = "d01b2c5449aaa2687f90bc71e092aaea"

class DataServiceManager {

    // MARK: - Properties
    static let sharedManager = DataServiceManager()

    // MARK: - Public APIs
    func fetchWeather(forCity city: String, completionHandler: ((success: Bool, cityWeather: CityWeatherDataModel?, error: String?) -> Void)?) {

//        http://api.openweathermap.org/data/2.5/weather?q=san%20francisco&appid=d01b2c5449aaa2687f90bc71e092aaeas

        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params: [String: AnyObject] = [
            "q": city,
            "appid": OpenWeatherAPIKey,
            "units": "metric"
        ]

        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                let cityWeather = CityWeatherDataModel(json: JSON(json))
                completionHandler?(success: true, cityWeather: cityWeather, error: nil)
            case .Failure(let error):
                completionHandler?(success: false, cityWeather: nil, error: "Request \(#function) failed with error: \(error).")
            }
        }
    }

    func fetchWeather(forLatitude lat: Double, longitude lon: Double, completionHandler: ((success: Bool, cityWeather: CityWeatherDataModel?, error: String?) -> Void)?) {

//        http://api.openweathermap.org/data/2.5/weather?lat=37.785834&lon=-122.406417&appid=d01b2c5449aaa2687f90bc71e092aaea

        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params: [String: AnyObject] = [
            "lat": lat,
            "lon": lon,
            "appid": OpenWeatherAPIKey,
            "units": "metric"
        ]

        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                let cityWeather = CityWeatherDataModel(json: JSON(json))
                completionHandler?(success: true, cityWeather: cityWeather, error: nil)
            case .Failure(let error):
                completionHandler?(success: false, cityWeather: nil, error: "Request \(#function) failed with error: \(error).")
            }
        }
    }

    func fetchWeathers(forCityIds cityIds: [NSNumber], completionHandler: ((success: Bool, cityWeathers: [CityWeatherDataModel], error: String?) -> Void)?) {
        
//        http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743&units=metric&appid=d01b2c5449aaa2687f90bc71e092aaea

        let ids = NSMutableString(string: "")
        cityIds.forEach({
            ids.appendString("\($0),")
        })
        let url = "http://api.openweathermap.org/data/2.5/group"
        let params: [String: AnyObject] = [
            "id": ids,
            "appid": OpenWeatherAPIKey,
            "units": "metric"
        ]

        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                if let response = json as? NSDictionary,
                    list = response["list"] as? NSArray {
                    
                    var cityWeathers: [CityWeatherDataModel] = []
                    list.forEach({
                        let cityWeather = CityWeatherDataModel(json: JSON($0))
                        cityWeathers.append(cityWeather)
                    })
                    completionHandler?(success: true, cityWeathers: cityWeathers, error: nil)
                }
                else {
                    completionHandler?(success: false, cityWeathers: [], error: "Error parsing \(#function) response.")
                }
            case .Failure(let error):
                completionHandler?(success: false, cityWeathers: [], error: "Request \(#function) failed with error: \(error).")
            }
        }
    }
}
