//
//  NetworkingHelper.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingHelper {
    
    private let URL = "http://api.openweathermap.org/data/2.5/find"
    private let translatorHelper = TranslatorHelper()
    
    func getCityList(latitude: Double, longitude: Double, callback: ([City]?, NSError?) -> Void) {
        let params = ["lat" : latitude, "lon" : longitude]
        Manager.sharedInstance.request(Method.GET, URL, parameters: params, encoding: ParameterEncoding.URL).response { (request, response, data, error) -> Void in
            let cities = self.translatorHelper.translateCityListFromJSON(data)
            callback(cities, error)
        }
    }
    
}