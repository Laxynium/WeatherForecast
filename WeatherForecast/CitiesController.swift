//
//  CitiesController.swift
//  WeatherForecast
//
//  Created by GG on 14/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import UIKit

protocol CitySelectionDelegate: class {
  func citySelected(_ newCity: City)
}

class CitiesController : UITableViewController{
    weak var cityDelegate: CitySelectionDelegate?
    weak var searchCityController: SearchCityController?
    private let citiesService: CitiesService
    @IBAction func onAddCity(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "SearchCityController") as? SearchCityController
        else{
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    private var cities:[City] = [
    ]
    required init?(coder: NSCoder) {
        self.citiesService = CitiesService()
        super.init(coder: coder)
        
        let ids = CitiesStorage.instance.getIds()
        getCitiesData(ids: ids)
        CitiesStorage.instance.subscribe(onChange: {newIds in
            self.getCitiesData(ids: newIds)
        })
    }
    private func getCitiesData(ids:[Int]){
        citiesService.getCitiesData(ids: ids.map({id in "\(id)"}))
               .observe(using: {r in
                   switch r {
                       case .success(let cities):
                           self.cities = cities.filter({c in c != nil}).map({c in c!})
                           DispatchQueue.main.async {
                               self.tableView.reloadData()
                           }
                       case .failure(let error):
                           debugPrint(error)
                   }
               })
    }
    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int)
        -> Int {
            return cities.count
    }
    
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            let city = cities[indexPath.row]
            cell.textLabel?.text = city.name;
            cell.detailTextLabel?.text = String(format:"%.2f ℃", city.temp)
            cell.imageView?.load(url: URL(string: city.weatherImg)!, onFinish: {() in
                cell.setNeedsLayout()
            })
     
            return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let city = self.cities[indexPath.row];
        cityDelegate?.citySelected(city)
        if let detailViewController = cityDelegate as? WeatherTableController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}
