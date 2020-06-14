//
//  SplitViewController.swift
//  WeatherForecast
//
//  Created by GG on 13/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import UIKit

class SplitViewController : UISplitViewController, UISplitViewControllerDelegate{
    override func viewDidLoad() {
           super.viewDidLoad()
           self.delegate = self
       }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
       return true
    }
}
