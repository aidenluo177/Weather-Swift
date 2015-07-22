//
//  TranslatorHelper.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import Foundation
import SwiftyJSON

class TranslatorHelper {
    
    func translateCityListFromJSON(data: AnyObject?) -> [City]? {
        if let data = data as? NSData{
            let json = JSON(data: data)
            if let jsonCities = json["list"].array {
                var cities = [City]()
                for jsonCity in jsonCities {
                    let city = City()
                    city.id = jsonCity["id"].intValue
                    city.name = jsonCity["name"].stringValue
                    city.temperature = jsonCity["main"]["temp"].doubleValue
                    city.pressure = jsonCity["main"]["pressure"].doubleValue
                    city.humidity = jsonCity["main"]["humidity"].doubleValue
                    cities.append(city)
                }
                return cities
            }
        }
        return nil
    }
    
}