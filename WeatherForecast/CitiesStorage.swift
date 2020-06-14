//
//  CitiesStorage.swift
//  WeatherForecast
//
//  Created by GG on 14/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation

class CitiesStorage {
    private var ids:[Int] = []
    private var onChange: (([Int])->Void)?;
    
    public static let instance:CitiesStorage = CitiesStorage()
   
    private init(){
        ids = [44418, 2487956, 2487796]
    }
    
    func getIds()->[Int]{
        return ids;
    }
    
    func subscribe(onChange: @escaping ([Int])->Void){
        self.onChange = onChange;
    }
    
    func addCity(id:Int){
        ids.append(id)
        onChange?(ids)
    }
}
