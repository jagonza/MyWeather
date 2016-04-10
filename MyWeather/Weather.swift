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
    private var _dailyWeatherArray: [DailyWeather]!
    private var _url: String!
    private var _dateForPrediction: NSTimeInterval!
    
    
    //MARK: - Public variables
    
    var currentWeather: CurrentWeather! {
        get {
            return _currentWeather
        }
        set(newValue) {
            _currentWeather = newValue
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
    
    var url: String! {
        return _url
    }
    
    var dateForPrediction: NSTimeInterval {
        return _dateForPrediction
    }
    
    //MARK: - Initializers
    
    init(latitud: String, longitud: String) {
        var urlStr = BASE_URL
        urlStr.appendContentsOf(API_ID_VALUE)
        urlStr.appendContentsOf("/")
        urlStr.appendContentsOf(latitud)
        urlStr.appendContentsOf(",")
        urlStr.appendContentsOf(longitud)
        
        let unitsParam = NSURLQueryItem(name: "units", value: "si")
        let urlComponents = NSURLComponents(string: urlStr)!
        urlComponents.queryItems = [unitsParam]
        _url = urlComponents.string
        
        _dateForPrediction = NSDate().timeIntervalSince1970
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let currentWeather = aDecoder.decodeObjectForKey(KEY_CURRENT_WEATHER) as? CurrentWeather {
            _currentWeather = currentWeather
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
        
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let currentWeather = _currentWeather {
            aCoder.encodeObject(currentWeather, forKey: KEY_CURRENT_WEATHER)
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
                    
                    self.dailyWeatherArray = [DailyWeather]()
                    
                    for dataWeather in dDataWeather {
                        let dailyWeather = DailyWeather()
                        dailyWeather.fillDailyDataWeather(dataWeather)
                        self.dailyWeatherArray.append(dailyWeather)
                    }
                    
                }
                
                completed()
            }
        }
    }

    
}
