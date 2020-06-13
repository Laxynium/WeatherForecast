//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GG on 10/03/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var weatherForDays:[WeatherInfo?] = []
    private var currentWeather:Int = 0;
    @IBOutlet weak var date: UILabel!
    @IBAction func onPrevious(_ sender: Any) {
        if(self.currentWeather > 0 ){
            self.currentWeather -= 1;
            loadData()
        }
    }
    @IBAction func onNext(_ sender: Any) {
        if(self.currentWeather < self.weatherForDays.count - 1){
            self.currentWeather+=1;
            loadData()
        }
    }
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var windDirection: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var pressue: UITextField!
    
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date();
        date.text = today.toString()
        let weatherForDays = WeatherService().getForNextDays(today)
        weatherForDays.observe(using: {r in
            switch r {
               case .success(let wI):
                   self.weatherForDays = wI.sorted(by: {a,b in
                       return a!.date <= b!.date
                   })
                   self.loadData();
               case .failure(let error):
                   debugPrint(error)
           }
        })
    }
    private func loadData(){
        DispatchQueue.main.async {
            let weather = self.weatherForDays[self.currentWeather]
            self.date.text = weather?.date.toString()
            self.weatherImg.load(url: URL(string: weather!.weatherStateImg)!)
            self.maxTemp.text = String(weather!.maxTemp)
            self.minTemp.text = String(weather!.minTemp)
            self.windSpeed.text = String(weather!.windSpeed)
            self.windDirection.text = String(weather!.windDirection)
            self.humidity.text = String(weather!.humidity)
            self.pressue.text = String(weather!.airPressure)
            
            if(self.currentWeather == 0){
                self.prevBtn.isEnabled = false;
            }else{
                self.prevBtn.isEnabled = true;
            }
            
            if(self.currentWeather == self.weatherForDays.count - 1){
                self.nextBtn.isEnabled = false;
            }else{
                self.nextBtn.isEnabled = true;
            }
        }
    }
}

