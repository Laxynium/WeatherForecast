//
//  DateExtension.swift
//  WeatherForecast
//
//  Created by GG on 12/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation

extension String{
    func toDate() -> Date?{
           let formatter4 = DateFormatter()
           formatter4.dateFormat = "yyyy-MM-dd"
           return formatter4.date(from: self)!
    }
}
extension Date{
    func toString()->String{
        let components = Calendar.current.dateComponents([.day, .year, .month], from: self)
        return "\(components.year!)/\(components.month!)/\(components.day!)"
    }
}
