//
//  Extensions.swift
//  ios_weather
//
//  Created by Weichuan Tian on 9/23/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func ext_addChildViewController(childViewController: UIViewController) {
        view.addSubview(childViewController.view)
        addChildViewController(childViewController)
        childViewController.didMoveToParentViewController(self)
    }

    func ext_removeFromParentViewController() {
        willMoveToParentViewController(nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}