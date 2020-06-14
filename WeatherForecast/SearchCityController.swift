//
//  SearchCityController.swift
//  WeatherForecast
//
//  Created by GG on 14/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import UIKit

class SearchCityController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var cities:[SimpleCity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultTable.delegate = self
        self.resultTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.resultTable.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.cities[indexPath.row];
        
        CitiesStorage.instance.addCity(id: Int(city.id)!);
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var cityName: UITextField!
    @IBAction func search(_ sender: Any) {
        self.cityName.endEditing(true)
        let cityName = self.cityName.text
        CitiesService().searchCity(name: cityName!)
        .observe(using: {result in
            switch result {
                case .success(let cities):
                    self.cities = cities.filter({c in c != nil}).map({c in c!})
                    DispatchQueue.main.async {
                        self.resultTable.reloadData()
                    }
                case .failure(let error):
                    debugPrint(error)
            }
        })
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
