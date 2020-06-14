//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by GG on 10/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation

struct WeatherInfo{
    let date: Date
    let weatherStateName: String
    let weatherStateAbbr: String
    let weatherStateImg: String
    let minTemp: Double
    let maxTemp: Double
    let windSpeed: Double
    let windDirection: String
    let airPressure: Double
    let humidity: Double
}
extension WeatherInfo {
    init?(json: [String: Any]){
        guard let date = (json["applicable_date"] as? String)?.toDate(),
            let weatherStateName = json["weather_state_name"] as? String,
            let weatherStateAbbr = json["weather_state_abbr"] as? String,
            let minTemp = json["min_temp"] as? Double,
            let maxTemp = json["max_temp"] as? Double,
            let windSpeed = json["wind_speed"] as? Double,
            let windDirection = json["wind_direction_compass"] as? String,
            let airPressure = json["air_pressure"] as? Double,
            let humidity = json["humidity"] as? Double
            else{
                return nil
        }
        self.date = date
        self.weatherStateName = weatherStateName
        self.weatherStateAbbr = weatherStateAbbr
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.airPressure = airPressure
        self.humidity = humidity
        self.weatherStateImg = "https://www.metaweather.com/static/img/weather/png/64/\(self.weatherStateAbbr).png"
    }
}

class WeatherService
{
    private let urlBase = "https://www.metaweather.com/api/location"
    func getForNextDays(_ cityId:String, _ today:Date)->Future<[WeatherInfo?]>{
        let dates = getDates(today)
            .map({d in self.toUrl(cityId: cityId, date: d)})
            .map(toTask)
            .map({(future:Future<Data>) in
                future.transformed(with: responseHandler)
            });
        return toFuture(list: dates)
    }
    private func responseHandler(_ data: Data?) -> WeatherInfo?{
        if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
            if let asList = json as? [Any]{
                if let firstMeasure = asList[0] as? [String: Any]{
                    let info = WeatherInfo(json: firstMeasure)
                    return info
                }
            }
        }
        return nil
    }
    
    private func toTask(url:URL) -> Future<Data>{
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
    private func toUrl(cityId: String,  date: String)->URL{
        return URL(string: "\(urlBase)/\(cityId)/\(date)")!
    }
    private func getDates(_ today:Date)->[String]{
        let dates = [today, addDay(today,1), addDay(today,2)]
        
        let asStrings = dates.map({(d:Date)->String in
            return d.toString()
            })
        return asStrings
    }
    private func addDay(_ date:Date, _ x:Int)->Date{
        return Calendar.current.date(byAdding: .day, value: x, to: date)!
    }
}
