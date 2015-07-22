//
//  City.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var temperature = 0.0
    dynamic var pressure = 0.0
    dynamic var humidity = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}