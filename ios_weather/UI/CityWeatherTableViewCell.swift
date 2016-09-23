//
//  CityWeatherTableViewCell.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit

class CityWeatherTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(withCityWeather cityWeather: CityWeatherDataModel) {
        nameLabel.text = cityWeather.name
        weatherLabel.text = cityWeather.weather
        tempLabel.text = "\(cityWeather.temp)°C"
    }
}
