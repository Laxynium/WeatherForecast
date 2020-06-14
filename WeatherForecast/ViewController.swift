//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GG on 10/03/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var controller: WeatherTableController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                 sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == "weatherTable"){
            self.controller =  segue.destination as? WeatherTableController
        }
    }
}

