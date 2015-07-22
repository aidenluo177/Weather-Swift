//
//  CityDetailViewController.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import UIKit

class CityDetailViewController: UITableViewController {

    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var temperatureCell: UITableViewCell!
    @IBOutlet weak var pressureCell: UITableViewCell!
    @IBOutlet weak var humidityCell: UITableViewCell!
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameCell.textLabel?.text = city.name
        temperatureCell.textLabel?.text = String(stringInterpolationSegment: city.temperature)
        pressureCell.textLabel?.text = String(stringInterpolationSegment: city.pressure)
        humidityCell.textLabel?.text = String(stringInterpolationSegment: city.humidity)
    }

}
