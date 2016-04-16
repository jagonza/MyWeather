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
//    @IBOutlet weak var precipProbLbl: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!
    @IBOutlet weak var lastUpdateDateLbl: UILabel!
    @IBOutlet weak var hourlySummary: UILabel!
    @IBOutlet weak var dailySummary: UILabel!
    
    
    //MARK: - Global variables
    
    var weather: Weather!
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    //MARK: - Live cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyForecastCollectionView.dataSource = self
        dailyForecastCollectionView.dataSource = self
        
        let locationEnabled = checkIfLocationIsEnabled()
        
        if locationEnabled {
            checkForCoordinates()
        }
        
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
//        if let weatherUD = Utils.getWeatherFromUserDefaults(latitude: latitude, longitude: longitude) {
//            if Utils.downloadLastWeatherInfo(weatherUD.dateForPrediction) {
//                downloadLastWeatherInfo()
//            } else {
//                weather = weatherUD
//                updateUI()
//            }
//        } else {
            downloadLastWeatherInfo()
//        }
    
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
//        precipProbLbl.text = weather.currentWeather.precipProb

        hourlySummary.text = weather.hourlySummary
        dailySummary.text = weather.dailySummary
        
        hourlyForecastCollectionView.reloadData()
        dailyForecastCollectionView.reloadData()
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if weather == nil {
            return 0
        } else {
            if collectionView == hourlyForecastCollectionView && weather.hourlyWeatherArray != nil{
                return weather.hourlyWeatherArray.count
            } else if collectionView == dailyForecastCollectionView && weather.dailyWeatherArray != nil {
                return weather.dailyWeatherArray.count - 1
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyForecastCollectionView {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HourlyForecastCVC", forIndexPath: indexPath) as? HourlyForeCastCVC {
                
                let hourlyWeather = weather.hourlyWeatherArray[indexPath.row]
                
                let dayNow = Utils.getDateStringFromTimeInterval(NSDate().timeIntervalSince1970, mask: "dd")
                let dayForecast = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "dd")

                if (Int(dayForecast)! - Int(dayNow)!) % 2 == 0 {
//                    cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 255/255, alpha: 1.0)
                    cell.backgroundColor = UIColor(red: 254/255, green: 222/255, blue: 139/255, alpha: 0.2)
                } else {
//                    cell.backgroundColor = UIColor(red: 207/255, green: 246/255, blue: 246/255, alpha: 1.0)
                    cell.backgroundColor = UIColor(red: 203/255, green: 194/255, blue: 172/255, alpha: 0.2)
                }
                
                let hour = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "HH")
//                cell.dayLbl.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
                if hour == "00" {
                    cell.dayLbl.hidden = false
                    cell.dayLbl.text = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "dd MMM.")
                } else {
                    cell.dayLbl.hidden = true
                }
                
                cell.hourLbl.text = hour + "h"
                cell.iconImg.image = UIImage(named: "\(hourlyWeather.icon)-1")
                cell.precipProb.text = hourlyWeather.precipProb
                cell.tempLbl.text = hourlyWeather.temperature
                
                return cell
            }
        } else if collectionView == dailyForecastCollectionView {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DailyForecastCVC", forIndexPath: indexPath) as? DailyForecastCVC {
                
                let dailyForecast: DailyWeather = weather.dailyWeatherArray[indexPath.row + 1]
                
                cell.dayOfWeekLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_WEEK).uppercaseString
                cell.dayOfMonthLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_MONTH)
                cell.iconImg.image = UIImage(named: "\(dailyForecast.icon)-1")
                cell.minTempLbl.text = dailyForecast.minTemp
                cell.maxTemLbl.text = dailyForecast.maxTemp
                
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