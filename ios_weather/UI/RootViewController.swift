//
//  RootViewController.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentViewController: CityWeatherConditionViewController? = nil
    private var hasFetchedLocation = false
    private var viewControllers: [String: CityWeatherConditionViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

private extension RootViewController {

    func switchToViewController(withTitle title: String, fromSidebar: Bool = false) {

        guard let targetViewController = viewControllers[title] else {
            return
        }

        if currentViewController == targetViewController {
//            if fromSidebar { toggleSidebar(isOpening: false, animated: true) }
            return
        }
        
//        if let sidebarIndex = currentSidebarTitles.indexOf(title) where !fromSidebar {
//            // If we are manually switching the view controller instead of selecting on the sidebar, we need to sync the sidebar select status.
//            sidebarViewController?.selectEntry(atIndex: sidebarIndex)
//        }
        
//        if fromSidebar { toggleSidebar(isOpening: false, animated: true) }
        currentViewController?.ext_removeFromParentViewController()

        currentViewController = targetViewController
        ext_addChildViewController(currentViewController!)

//        view.bringSubviewToFront(invisibleButton!)
//        view.bringSubviewToFront(sidebarViewController!.view)
    }
}

// MARK: - CLLocationManagerDelegate
extension RootViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hasFetchedLocation {
            manager.stopUpdatingLocation()
            return
        }

        if let userLocation = locations.first {
            hasFetchedLocation = true
            let currentLocViewController = CityWeatherConditionViewController.init(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            currentLocViewController.view.frame = view.bounds
            currentLocViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            currentLocViewController.delegate = self
            viewControllers["Current Location"] = currentLocViewController
            switchToViewController(withTitle: "Current Location")
        }
        
    }
}

// MARK: - CityWeatherConditionViewControllerDelegate
extension RootViewController: CityWeatherConditionViewControllerDelegate {

    func didTapSidebarButton(fromViewController vc: CityWeatherConditionViewController) {
        
    }

    func didTapPlusButton(fromViewController vc: CityWeatherConditionViewController) {

        let alertController = UIAlertController(title: "Enter city", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Type the city you're interested"
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        let OKAction = UIAlertAction(title: "Add", style: .Default) { [weak self] _ in
            guard let strongSelf = self, cityName = alertController.textFields?.first?.text where !cityName.isEmpty else {
                return
            }

            let currentCityViewController = CityWeatherConditionViewController(withCityName: cityName)
            currentCityViewController.view.frame = strongSelf.view.bounds
            currentCityViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            currentCityViewController.delegate = strongSelf
            strongSelf.viewControllers[cityName] = currentCityViewController
            strongSelf.switchToViewController(withTitle: cityName)
        }
        alertController.addAction(OKAction)

        presentViewController(alertController, animated: false, completion: nil)
    }
}
