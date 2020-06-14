//
//  CitiesServices.swift
//  WeatherForecast
//
//  Created by GG on 14/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation

struct City{
    let id: String
    let name:String
    let temp:Double
    let weatherImg:String
}

extension City {
    init?(json: [String: Any]){
        guard let id =  json["woeid"] as? Int,
            let title = json["title"] as? String,
            let weather = json["consolidated_weather"] as? [[String:Any]],
            let temp = weather[0]["the_temp"] as? Double,
            let weatherImg = weather[0]["weather_state_abbr"] as? String
        else {
            return nil            
        }
       
        self.id = "\(id)"
        self.name = title
        self.temp = temp
        self.weatherImg = "https://www.metaweather.com/static/img/weather/png/64/\(weatherImg).png"
    }
}

class CitiesService
{
    private let urlBase = "https://www.metaweather.com/api/location"
    
    func getCitiesData(ids:[String]) -> Future<[City?]>{
        let urls = ids.map({id in URL(string: "\(urlBase)/\(id)")!})
        let cities = urls
            .map({url in toTask(url: url)})
            .map({f in f.transformed(with: {data in
                self.responseHandler(data)
            })})
        return toFuture(list: cities)
    }
    
    private func responseHandler(_ data: Data?) -> City?{
        if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
            debugPrint(json)
            if let obj = json as? [String:Any]{
                return City(json: obj)
            }
        }
        return nil
    }
    
    func toTask(url:URL) -> Future<Data>{
        let promise = Promise<Data>()
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
           if let error = error {
               promise.reject(with: error)
           } else {
               promise.resolve(with: data ?? Data())
           }
        })
        task.resume()
        return promise
    }
    
}
