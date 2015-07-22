//
//  CityListViewController.swift
//  Weather
//
//  Created by aidenluo on 15/7/22.
//  Copyright (c) 2015年 36kr. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class CityListViewController: UITableViewController {

    private let cityCellIdentifier = "CityListCell"
    private let showCityDetailSegueIdentifier = "ShowDetail"
    private let networkingHelper = NetworkingHelper()
    private let databaseHelper = DatabaseHelper()
    private var cityList = Realm().objects(City)
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupLocationManager()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cityCellIdentifier) as! UITableViewCell
        let city = cityList[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let city = cityList[indexPath.row]
        performSegueWithIdentifier(showCityDetailSegueIdentifier, sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showCityDetailSegueIdentifier {
            let destination = segue.destinationViewController as! CityDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let city = cityList[indexPath.row]
                destination.city = city
            }
        }
    }
    
    func loadCityListFromNetwork(latitude: Double, longitude: Double) {
        networkingHelper.getCityList(latitude, longitude: longitude) { (cities, error) -> Void in
            self.refreshControl?.endRefreshing()
            if let error = error {
                let alert = UIAlertController(title: "出错了", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                if let cities = cities {
                    self.databaseHelper.storeCityList(cities, callback: { () -> Void in
                        self.loadCityFromDatabase()
                    })
                }
            }
        }
    }
    
    func loadCityFromDatabase() {
        cityList = Realm().objects(City)
        tableView.reloadData()
    }

}

// MARK: - Config

extension CityListViewController: CLLocationManagerDelegate{
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("onRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func onRefresh(sender: AnyObject?) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            self.refreshControl?.endRefreshing()
            let alert = UIAlertController(title: "需要您的授权", message: "请前往 设置->隐私->定位服务 进行授权", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count == 0 {
            return
        }
        let location: CLLocation = locations.first as! CLLocation
        loadCityListFromNetwork(location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            onRefresh(self.refreshControl)
        }
    }
}
