//
//  ViewController.swift
//  MyWeather
//
//  Created by Javier González Rojo on 3/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var precipProbLbl: UILabel!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    
    
    //MARK: - Global variables
    
    var weather: Weather!
    
    //MARK: - Live cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.registerNib(UINib(nibName: "DailyForecastTVC", bundle: nil), forCellReuseIdentifier: "DailyForecastCell")
        hourlyForecastCollectionView.dataSource = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Helper functions
    
    func loadWeather() {
        
        if let weatherUD = Utils.getWeatherFromUserDefaults(API_LAT_VALUE, longitude: API_LON_VALUE) {
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
        //MARK: TODO: ESTOS VALORES NO PUEDEN ESTAR HARDCODEADOS
        weather = Weather(latitud: API_LAT_VALUE, longitud: API_LON_VALUE)
        weather.downloadWeaher{ () -> () in
            Utils.storeWeatherIntoUserDefaults(API_LAT_VALUE, longitude: API_LON_VALUE, weather: self.weather)
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        let todayForecast:DailyWeather = weather.dailyWeatherArray[0]
        
        currentWeatherImg.image = UIImage(named: "\(weather.currentWeather.icon)-big")
        currentTempLbl.text = weather.currentWeather.currentTemp
        minTempLbl.text = todayForecast.minTemp
        maxTempLbl.text = todayForecast.maxTemp
        precipProbLbl.text = weather.currentWeather.precipProb
        
        dailyForecastTableView.reloadData()
        hourlyForecastCollectionView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = dailyForecastTableView.dequeueReusableCellWithIdentifier("DailyForecastCell", forIndexPath: indexPath) as? DailyForecastTVC {
            
            let dailyForecast: DailyWeather = weather.dailyWeatherArray[indexPath.row + 1]
            
            cell.dayOfWeekLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_WEEK).uppercaseString
            cell.dayOfMonthLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_MONTH)
            cell.iconImg.image = UIImage(named: "\(dailyForecast.icon)-1")
            cell.minTempLbl.text = dailyForecast.minTemp
            cell.maxTemLbl.text = dailyForecast.maxTemp
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weather.dailyWeatherArray != nil {
            return weather.dailyWeatherArray.count - 1
        } else {
            return 0
        }
        
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if weather.hourlyWeatherArray != nil {
            return 12
        } else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HourlyForeCastCVC", forIndexPath: indexPath) as? HourlyForeCastCVC {
            
            let hourlyWeather = weather.hourlyWeatherArray[indexPath.row]
            
            cell.hourLbl.text = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "HH")
            cell.iconImg.image = UIImage(named: "\(hourlyWeather.icon)-1")
            cell.precipProb.text = hourlyWeather.precipProb
            cell.tempLbl.text = hourlyWeather.temperature
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
}