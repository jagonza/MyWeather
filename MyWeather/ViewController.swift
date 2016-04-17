//
//  ViewController.swift
//  MyWeather
//
//  Created by Javier González Rojo on 3/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var currentSummary:UILabel!
    @IBOutlet weak var currentDayLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var lastUpdateDateLbl: UILabel!
    @IBOutlet weak var hourlySummary: UILabel!
    @IBOutlet weak var dailySummary: UILabel!
    
    @IBOutlet weak var outerView: UIView!
    
    
    //MARK: - Global variables
    
    var weather: Weather!
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    //MARK: - Live cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyForecastCollectionView.dataSource = self
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.tableFooterView = UIView(frame: CGRectZero)
        dailyForecastTableView.backgroundColor = UIColor(red: 254/255, green: 243/255, blue: 215/255, alpha: 1.0)
        
        let locationEnabled = checkIfLocationIsEnabled()
        
        if locationEnabled {
            checkForCoordinates()
        }
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(refreshView(_:)), name: "reloadWeather", object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func timeMachineButtonTapped(sender: UIButton) {
        
        weather = Weather(latitude: "\(latitude)", longitude: "\(longitude)", time: 1435248000)
        weather.downloadWeaher{ () -> () in
            self.updateUI()
        }

    }
    
    //MARK: - Helper functions

    
    func refreshView(notification: NSNotification) {
        loadWeather()
    }
    
    func checkIfLocationIsEnabled() -> Bool {
        locationManager.requestWhenInUseAuthorization()
        return true
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .NotDetermined, .Restricted, .Denied:
//                //Han denegado la localización pedir acceso de nuevo y
//                //si no sacar nube triste
//                return false
//            case .AuthorizedAlways, .AuthorizedWhenInUse:
//                //la atuorización está concedida
//                return true
//            }
//        } else {
//            //todos los servicios de localización están desactivados
//            return false
//        }
    }
    
    func checkForCoordinates() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadWeather() {
        if let weatherUD = Utils.getWeatherFromUserDefaults(latitude: latitude, longitude: longitude) {
            if Utils.downloadLastWeatherInfo(weatherUD.dateForPrediction) {
                downloadLastWeatherInfo()
            } else {
                weather = weatherUD
                updateUI()
            }
        } else {
            downloadLastWeatherInfo()
        }
    
    }
    
    
    func downloadLastWeatherInfo() {
        weather = Weather(latitude: "\(latitude)", longitude: "\(longitude)")
        weather.downloadWeaher{ () -> () in
            Utils.storeWeatherIntoUserDefaults(latitude: self.latitude, longitude: self.longitude, weather: self.weather)
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        let todayForecast:DailyWeather = weather.dailyWeatherArray[0]
        
        lastUpdateDateLbl.text = "Última actualización: \(Utils.getDateStringFromTimeInterval(weather.dateForPrediction, mask: "dd MMM HH:mm"))"
        
        currentWeatherImg.image = UIImage(named: "\(weather.currentWeather.icon)-big")
        currentTempLbl.text = weather.currentWeather.currentTemp
        currentSummary.text = weather.currentWeather.summary
        currentDayLbl.text = Utils.getDateStringFromTimeInterval(NSDate().timeIntervalSince1970, mask: "EEEE, d 'de' MMMM")
        minTempLbl.text = todayForecast.minTemp
        maxTempLbl.text = todayForecast.maxTemp
        sunriseLbl.text = todayForecast.sunriseTime
        sunsetLbl.text = todayForecast.sunsetTime

        hourlySummary.text = weather.hourlySummary
        dailySummary.text = weather.dailySummary
        
        hourlyForecastCollectionView.reloadData()
        dailyForecastTableView.reloadData()
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    func hoursToDisplay() -> Int {
        var i = 0;
        if weather != nil && weather.hourlyWeatherArray != nil
            && weather.hourlyWeatherArray.count > 0 {
            let now = NSDate().timeIntervalSince1970
            for hour in weather.hourlyWeatherArray {
                if hour.time > now {
                    i += 1;
                }
            }
        }
        return i;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hoursToDisplay()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyForecastCollectionView {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HourlyForecastCVC", forIndexPath: indexPath) as? HourlyForeCastCVC {
                
                let startHour = weather.hourlyWeatherArray.count - hoursToDisplay()
                
                let hourlyWeather = weather.hourlyWeatherArray[indexPath.row + startHour]
                
                let dayNow = Utils.getDateStringFromTimeInterval(NSDate().timeIntervalSince1970, mask: "dd")
                let dayForecast = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "dd")

                if (Int(dayForecast)! - Int(dayNow)!) % 2 == 0 {
                    cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
                } else {
                    cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
                }
                
                let hour = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "HH")
                if hour == "00" {
                    cell.dayLbl.hidden = false
                    cell.dayLbl.text = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "dd MMM.")
                } else {
                    cell.dayLbl.hidden = true
                }
                
                cell.hourLbl.text = hour + "h"
                cell.iconImg.image = UIImage(named: "\(hourlyWeather.icon)")
                cell.precipProb.text = hourlyWeather.precipProb
                cell.tempLbl.text = hourlyWeather.temperature
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil

        let location: CLLocationCoordinate2D = manager.location!.coordinate        
        latitude = location.latitude
        longitude = location.longitude
        
        LocationHelper.getLocationNameFromCoordinates(latitude: latitude, longitude: longitude) { (name) in
            self.locationNameLbl.text = name
            self.loadWeather()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func daysToDisplay() -> Int {
        var i = 0;
        if weather != nil && weather.dailyWeatherArray != nil
            && weather.dailyWeatherArray.count > 0 {
            let today = NSDate().timeIntervalSince1970
            for day in weather.dailyWeatherArray {
                if day.day > today {
                    i += 1;
                }
            }
        }
        return i;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysToDisplay()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == dailyForecastTableView {
            if let cell = tableView.dequeueReusableCellWithIdentifier("DailyForecastTVC", forIndexPath: indexPath) as? DailyForecastTVC {
                
                let startDay = weather.dailyWeatherArray.count - daysToDisplay()
                
                let dailyForecast: DailyWeather = weather.dailyWeatherArray[indexPath.row + startDay]
                
                cell.dayOfWeekLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_WEEK).uppercaseString
                cell.dayOfMonthLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_MONTH)
                cell.iconImg.image = UIImage(named: "\(dailyForecast.icon)")
                cell.minTempLbl.text = dailyForecast.minTemp
                cell.maxTemLbl.text = dailyForecast.maxTemp
                
                cell.selectionStyle = .None
                
                return cell
            }
        }
        return UITableViewCell()
    }

}