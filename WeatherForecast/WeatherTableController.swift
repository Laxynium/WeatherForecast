//
//  WeatherTableController.swift
//  WeatherForecast
//
//  Created by GG on 13/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableController : UITableViewController {
    private var weatherForDays:[WeatherInfo?] = []
    private var currentWeather:Int = 0;
    var cityId: String? = "523920" {
        didSet {
            loadViewIfNeeded()
            fetchData()
        }
    }
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var weatherState: UITextField!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var windDirection: UITextField!
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var pressure: UITextField!
    
    @IBAction func onPrev(_ sender: Any) {
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
    private func fetchData() {
        let today = Date();
        date.text = today.toString()
        let weatherForDays = WeatherService().getForNextDays(cityId!, today)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    public func changeCity(_ city: City?){
        self.cityId = city?.id
    }
    
    private func loadData(){
        DispatchQueue.main.async {
            let weather = self.weatherForDays[self.currentWeather]
            if(weather != nil){
                self.date.text = weather?.date.toString()
                self.weatherState.text = weather?.weatherStateName
                self.weatherImg.load(url: URL(string: weather!.weatherStateImg)!)
                self.maxTemp.text = String(format:"%.2f ℃",weather!.maxTemp)
                self.minTemp.text = String(format:"%.2f ℃",weather!.minTemp)
                self.windSpeed.text = String(format:"%.2f",weather!.windSpeed)
                self.windDirection.text = String(weather!.windDirection)
                self.humidity.text = String(format:"%.2f",weather!.humidity)
                self.pressure.text = String(format:"%.2f",weather!.airPressure)
            }
             
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

extension WeatherTableController : CitySelectionDelegate{
    func citySelected(_ newCity: City) {
        self.changeCity(newCity)
    }
}
