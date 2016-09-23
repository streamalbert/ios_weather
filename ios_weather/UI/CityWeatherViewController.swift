//
//  CityWeatherViewController.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit
import CoreLocation

private let CityWeatherTableViewCellReuseIdentifier = "CityWeatherTableViewCellReuseIdentifier"

class CityWeatherViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private var cityWeathers: [CityWeatherDataModel] = []
    private var refreshControl: UIRefreshControl? = nil
    let locationManager = CLLocationManager()
    var lon: CLLocationDegrees? = nil
    var lat: CLLocationDegrees? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        navigationItem.title = "Weather"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addBarButtonItemTapped(_:)))

        tableView.registerNib(UINib(nibName: String(CityWeatherTableViewCell), bundle: nil), forCellReuseIdentifier: CityWeatherTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView()

        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(hasTriggeredRefresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }
}

// MARK: - Private Extension
private extension CityWeatherViewController {

    // MARK: - Private Helpers
    @objc func hasTriggeredRefresh(sender: UIRefreshControl) {
        if cityWeathers.count == 0 {
            return
        }
        let cityIds = cityWeathers.map({ $0.id })
        DataServiceManager.sharedManager.fetchWeathers(forCityIds: cityIds) { (success, cityWeathers, error) in
            self.refreshControl?.endRefreshing()
            if success {
                self.cityWeathers = cityWeathers
                self.tableView.reloadData()
            }
        }
    }

    @objc func addBarButtonItemTapped(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Enter city", message: nil, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Type the city you're interested"
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        let OKAction = UIAlertAction(title: "Add", style: .Default) { _ in
            guard let cityName = alertController.textFields?.first?.text where !cityName.isEmpty else {
                return
            }

            DataServiceManager.sharedManager.fetchWeather(forCity: cityName, completionHandler: { (success, cityWeather, error) in
                if success, let cityWeather = cityWeather where cityWeather.name.lowercaseString == cityName.lowercaseString {
                    self.cityWeathers.append(cityWeather)
                    self.tableView.reloadData()
                }
                else {
                    let failAlert = UIAlertController(title: "Oops!", message: "Something went wrong, please try again!", preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: false, completion: nil)
                }
            })
        }
        alertController.addAction(OKAction)

        presentViewController(alertController, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CityWeatherViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeathers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CityWeatherTableViewCellReuseIdentifier, forIndexPath: indexPath) as! CityWeatherTableViewCell
        cell.populate(withCityWeather: cityWeathers[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            cityWeathers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension CityWeatherViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
}

// MARK: - CLLocationManagerDelegate
extension CityWeatherViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lat != nil && lon != nil {
            manager.stopUpdatingLocation()
            return
        }
        
        if let userLocation = locations.first {
            lon = userLocation.coordinate.longitude
            lat = userLocation.coordinate.latitude
            DataServiceManager.sharedManager.fetchWeather(forLatitude: lat!, longitude: lon!, completionHandler: { (success, cityWeather, error) in
                if success, let cityWeather = cityWeather {
                    self.cityWeathers.append(cityWeather)
                    self.tableView.reloadData()
                }
            })
        }
        
    }
}
