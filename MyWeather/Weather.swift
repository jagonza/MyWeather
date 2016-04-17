//
//  Weather.swift
//  MyWeather
//
//  Created by Javier González Rojo on 9/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation
import Alamofire

class Weather: NSObject, NSCoding {
    
    //MARK: - Global variables
    
    private var _currentWeather: CurrentWeather!
    private var _horylyWeatherArray: [HourlyWeather]!
    private var _dailyWeatherArray: [DailyWeather]!
    private var _url: String!
    private var _dateForPrediction: NSTimeInterval!
    private var _hourlySummary: String?
    private var _dailySummary: String?
    
    
    //MARK: - Public variables
    
    var currentWeather: CurrentWeather! {
        get {
            return _currentWeather
        }
        set(newValue) {
            _currentWeather = newValue
        }
    }
    
    var hourlyWeatherArray: [HourlyWeather]! {
        get {
            return _horylyWeatherArray
        }
        set(newValue) {
            _horylyWeatherArray = newValue
        }
    }
    
    var dailyWeatherArray: [DailyWeather]! {
        get {
            return _dailyWeatherArray
        }
        set(newValue) {
            _dailyWeatherArray = newValue
        }
    }
    
    var url: String {
        return _url
    }
    
    var dateForPrediction: NSTimeInterval {
        return _dateForPrediction
    }
    
    var hourlySummary: String {
        if _hourlySummary == nil {
            return ""
        } else {
            return _hourlySummary!
        }
    }
    
    var dailySummary: String {
        if _dailySummary == nil {
            return ""
        } else {
            return _dailySummary!
        }
    }
    
    //MARK: - Initializers
    
    convenience init(latitude: String, longitude: String) {
        self.init(latitude: latitude, longitude: longitude, time: nil)
    }
    
    init(latitude: String, longitude: String, time: Int?) {
        var urlStr = BASE_URL
        urlStr.appendContentsOf(API_ID_VALUE)
        urlStr.appendContentsOf("/")
        urlStr.appendContentsOf(latitude)
        urlStr.appendContentsOf(",")
        urlStr.appendContentsOf(longitude)
        
        if let time = time {
            urlStr.appendContentsOf(",")
            urlStr.appendContentsOf("\(time)")
        }
        
        let unitsParam = NSURLQueryItem(name: "units", value: "si")
        let langParam = NSURLQueryItem(name: "lang", value: "es")
        let urlComponents = NSURLComponents(string: urlStr)!
        urlComponents.queryItems = [unitsParam, langParam]
        _url = urlComponents.string
        
        _dateForPrediction = NSDate().timeIntervalSince1970
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let currentWeather = aDecoder.decodeObjectForKey(KEY_CURRENT_WEATHER) as? CurrentWeather {
            _currentWeather = currentWeather
        }
        
        if let hourlyWeatherArray = aDecoder.decodeObjectForKey(KEY_HOURLY_WEATHER_ARRAY) as? [HourlyWeather]{
            _horylyWeatherArray = hourlyWeatherArray
        }
        
        if let dailyWeatherArray = aDecoder.decodeObjectForKey(KEY_DAILY_WEATHER_ARRAY) as? [DailyWeather] {
            _dailyWeatherArray = dailyWeatherArray
        }
        
        if let url = aDecoder.decodeObjectForKey(KEY_URL) as? String {
            _url = url
        }
        
        if let dateForPrediction = aDecoder.decodeObjectForKey(KEY_DATE_FOR_PREDICTION) as? NSTimeInterval {
            _dateForPrediction = dateForPrediction
        }
        
        if let hourlySummary = aDecoder.decodeObjectForKey(KEY_HOURLY_SUMMARY) as? String {
            _hourlySummary = hourlySummary
        }
        
        if let dailySummary = aDecoder.decodeObjectForKey(KEY_DAILY_SUMMARY) as? String {
            _dailySummary = dailySummary
        }
        
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let currentWeather = _currentWeather {
            aCoder.encodeObject(currentWeather, forKey: KEY_CURRENT_WEATHER)
        }
        
        if let hourlyWeatherArray = _horylyWeatherArray {
            aCoder.encodeObject(hourlyWeatherArray, forKey: KEY_HOURLY_WEATHER_ARRAY)
        }
        
        if let dailyWeatherArray = _dailyWeatherArray {
            aCoder.encodeObject(dailyWeatherArray, forKey: KEY_DAILY_WEATHER_ARRAY)
        }
        
        if let url = _url {
            aCoder.encodeObject(url, forKey: KEY_URL)
        }
        
        if let dateForPrediction = _dateForPrediction {
            aCoder.encodeObject(dateForPrediction, forKey: KEY_DATE_FOR_PREDICTION)
        }
        
        if let hourlySummary = _hourlySummary {
            aCoder.encodeObject(hourlySummary, forKey: KEY_HOURLY_SUMMARY)
        }
        
        if let dailySummary = _dailySummary {
            aCoder.encodeObject(dailySummary, forKey: KEY_DAILY_SUMMARY)
        }
        
    }
    
    //MARK: - Helper functions
    
    func downloadWeaher(completed: DownloadCompleted) {
        
        Alamofire.request(.GET, _url).responseJSON { response in
                        
            if let weatherJSON = response.result.value as? Dictionary<String, AnyObject> {
                
                if let currWeather = weatherJSON["currently"] as? Dictionary<String, AnyObject> {
                    
                    self.currentWeather = CurrentWeather()
                    self.currentWeather.fillCurrentWeatherInfo(currWeather)
                    
                }
                
                if let dWeather = weatherJSON["daily"] as? Dictionary<String, AnyObject>,
                    let dDataWeather = dWeather["data"] as? [Dictionary<String, AnyObject>] where dDataWeather.count > 0 {
                    
                    self._dailySummary = Utils.getOptionalStringFromDictionary(KEY_SUMMARY, dict: dWeather)
                    
                    self.dailyWeatherArray = [DailyWeather]()
                    
                    for dataWeather in dDataWeather {
                        let dailyWeather = DailyWeather()
                        dailyWeather.fillDailyDataWeather(dataWeather)
                        self.dailyWeatherArray.append(dailyWeather)
                    }
                    
                }
                
                if let hWeather = weatherJSON["hourly"] as? Dictionary<String, AnyObject>,
                    let hDataWeather = hWeather["data"] as? [Dictionary<String, AnyObject>] where hDataWeather.count > 0 {
                    
                    self._hourlySummary = Utils.getOptionalStringFromDictionary(KEY_SUMMARY, dict: hWeather)
                    
                    self.hourlyWeatherArray = [HourlyWeather]()
                    
                    for dataWeather in hDataWeather {
                        let hourlyWeather = HourlyWeather()
                        hourlyWeather.fillHourlyDataWeather(dataWeather)
                        self.hourlyWeatherArray.append(hourlyWeather)
                    }
                    
                }
                
                completed()
            }
        }
    }

    
}
