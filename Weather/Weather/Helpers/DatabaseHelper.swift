//
//  DatabaseHelper.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseHelper {
    
    func storeCityList(cities: [City], callback: (() -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let realm = Realm()
            realm.write({ () -> Void in
                for city in cities {
                    realm.add(city, update: true)
                }
                dispatch_async(dispatch_get_main_queue(), callback)
            })
        })
    }
    
}
