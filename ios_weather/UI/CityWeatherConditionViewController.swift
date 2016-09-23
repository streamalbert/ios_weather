//
//  CityWeatherConditionViewController.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit

private let WeatherConditionIcon = [
    "01d": "weather-clear",
    "02d": "weather-few",
    "03d": "weather-few",
    "04d": "weather-broken",
    "09d": "weather-shower",
    "10d": "weather-rain",
    "11d": "weather-tstorm",
    "13d": "weather-snow",
    "50d": "weather-mist",
    "01n": "weather-moon",
    "02n": "weather-few-night",
    "03n": "weather-few-night",
    "04n": "weather-broken",
    "09n": "weather-shower",
    "10n": "weather-rain-night",
    "11n": "weather-tstorm",
    "13n": "weather-snow",
    "50n": "weather-mist",
]

protocol CityWeatherConditionViewControllerDelegate: class {
    func didTapSidebarButton(fromViewController vc: CityWeatherConditionViewController)
    func didTapPlusButton(fromViewController vc: CityWeatherConditionViewController)
}

class CityWeatherConditionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var forcastLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!

    // MARK: - Properties
    private let lon: Double?
    private let lat: Double?
    private(set) var cityName: String?
    var delegate: CityWeatherConditionViewControllerDelegate?

    init(withLatitude lat: Double, longitude lon: Double) {
        self.lat = lat
        self.lon = lon
        cityName = nil
        super.init(nibName: String(CityWeatherConditionViewController), bundle: nil)
    }

    init(withCityName city: String) {
        lat = nil
        lon = nil
        cityName = city
        super.init(nibName: String(CityWeatherConditionViewController), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        cityLabel.text = "Loading..."
        if lat != nil && lon != nil {
            DataServiceManager.sharedManager.fetchWeather(forLatitude: lat!, longitude: lon!, completionHandler: { (success, cityWeather, error) in
                if success, let cityWeather = cityWeather {
                    self.populate(withCityWeather: cityWeather)
                }
                else {
                    let failAlert = UIAlertController(title: "Oops!", message: "Something went wrong, please revisit this page!", preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: false, completion: nil)
                }
            })
        }
        else if cityName != nil {
            DataServiceManager.sharedManager.fetchWeather(forCity: cityName!, completionHandler: { (success, cityWeather, error) in
                if success, let cityWeather = cityWeather {
                    self.populate(withCityWeather: cityWeather)
                }
                else {
                    let failAlert = UIAlertController(title: "Oops!", message: "Something went wrong, please revisit this page!", preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: false, completion: nil)
                }
            })
        }
    }

    func populate(withCityWeather cityWeather: CityWeatherDataModel) {
        cityLabel.text = cityWeather.name
        conditionImageView.image = UIImage(named: WeatherConditionIcon[cityWeather.weatherIcon] ?? "")
        conditionLabel.text = cityWeather.weather
        tempLabel.text = "\(cityWeather.temp.integerValue)°"
        forcastLabel.text = "\(cityWeather.tempMax.integerValue)° / \(cityWeather.tempMin.integerValue)°"
    }

    @IBAction func didTapSidebarButton(sender: UIButton) {
        delegate?.didTapSidebarButton(fromViewController: self)
    }

    @IBAction func didTapPlusButton(sender: UIButton) {
        delegate?.didTapPlusButton(fromViewController: self)
    }
}
