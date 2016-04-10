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
    
    //MARK: - Global variables
    
    var weather: Weather!
    
    //MARK: - Live cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.registerNib(UINib(nibName: "DailyForecastTVC", bundle: nil), forCellReuseIdentifier: "DailyForecastCell")
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
        
//        if let weatherUD = Utils.getWeatherFromUserDefaults(API_LAT_VALUE, longitude: API_LON_VALUE) {
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
        //MARK: TODO: ESTOS VALORES NO PUEDEN ESTAR HARDCODEADOS
        weather = Weather(latitud: API_LAT_VALUE, longitud: API_LON_VALUE)
        weather.downloadWeaher{ () -> () in
            Utils.storeWeatherIntoUserDefaults(API_LAT_VALUE, longitude: API_LON_VALUE, weather: self.weather)
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        let todayForecast:DailyWeather = weather.dailyWeatherArray[0]
        
        currentWeatherImg.image = UIImage(named: weather.currentWeather.icon)
        currentTempLbl.text = weather.currentWeather.currentTemp
        minTempLbl.text = todayForecast.minTemp
        maxTempLbl.text = todayForecast.maxTemp
        precipProbLbl.text = weather.currentWeather.precipProb
        
        dailyForecastTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = dailyForecastTableView.dequeueReusableCellWithIdentifier("DailyForecastCell", forIndexPath: indexPath) as? DailyForecastTVC {
            
//            if weather.currentWeather != nil {
            
                let dailyForecast: DailyWeather = weather.dailyWeatherArray[indexPath.row]
                
                cell.dayOfWeekLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_WEEK).uppercaseString
                cell.dayOfMonthLbl.text = Utils.getDateStringFromTimeInterval(dailyForecast.day, mask: MASK_DAY_OF_MONTH)
                cell.iconImg.image = UIImage(named: dailyForecast.icon)
                cell.minTempLbl.text = dailyForecast.minTemp
                cell.maxTemLbl.text = dailyForecast.maxTemp
//            }
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weather.dailyWeatherArray != nil {
            return weather.dailyWeatherArray.count
        } else {
            return 0
        }
        
    }
    
}



