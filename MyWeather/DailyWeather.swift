//
//  DailyWeather.swift
//  MyWeather
//
//  Created by Javier González Rojo on 6/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation

class DailyWeather: NSObject, NSCoding {
    
    //MARK: - Global variables

    private var _day: Double?
    private var _maxTemp: Double?
    private var _minTemp: Double?
    private var _icon: String?
    private var _sunriseTime: Int?
    private var _sunsetTime: Int?
    
    //MARK: Public variables
    
    var day: NSTimeInterval {
        if _day == nil {
            return NSDate().timeIntervalSince1970
        } else {
            return NSTimeInterval(_day!)
        }
    }
    
    var maxTemp: String {
        if _maxTemp == nil {
            return ""
        } else {
            return "\(Int(_maxTemp!))º"
        }
    }
    
    var minTemp: String {
        if _minTemp == nil {
            return ""
        } else {
            return "\(Int(_minTemp!))º"
        }
    }
    
    var icon: String {
        if _icon == nil {
            return ""
        } else {
            return _icon!
        }
    }
    
    var sunriseTime: String {
        if _sunriseTime == nil {
            return ""
        } else {
            return Utils.getStringHoursFromSeconds(_sunriseTime!)
        }
    }
    
    var sunsetTime: String {
        if _sunsetTime == nil {
            return ""
        } else {
            return Utils.getStringHoursFromSeconds(_sunsetTime!)
        }
    }
    
    //MARK: - Initializers
    
    override init() {
        _day = NSDate().timeIntervalSince1970
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        if let day = aDecoder.decodeObjectForKey(KEY_TIME) as? Double {
            _day = day
        }
        
        if let minTemp = aDecoder.decodeObjectForKey(KEY_TEMPERATURE_MIN) as? Double {
            _minTemp = minTemp
        }
        
        if let maxTemp = aDecoder.decodeObjectForKey(KEY_TEMPERATURE_MAX) as? Double {
            _maxTemp = maxTemp
        }
        
        if let icon = aDecoder.decodeObjectForKey(KEY_ICON) as? String {
            _icon = icon
        }
        
        if let sunrise = aDecoder.decodeObjectForKey(KEY_SUNRISE_TIME) as? Int {
            _sunriseTime = sunrise
        }
        
        if let sunset = aDecoder.decodeObjectForKey(KEY_SUNSET_TIME) as? Int {
            _sunsetTime = sunset
        }
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let day = _day  {
            aCoder.encodeObject(day, forKey: KEY_TIME)
        }
        
        if let minTemp = _minTemp {
            aCoder.encodeObject(minTemp, forKey: KEY_TEMPERATURE_MIN)
        }
        
        if let maxTemp = _maxTemp {
            aCoder.encodeObject(maxTemp, forKey: KEY_TEMPERATURE_MAX)
        }
        
        if let icon = _icon {
            aCoder.encodeObject(icon, forKey: KEY_ICON)
        }
        
        if let sunrise = _sunriseTime {
            aCoder.encodeObject(sunrise, forKey: KEY_SUNRISE_TIME)
        }
        
        if let sunset = _sunsetTime {
            aCoder.encodeObject(sunset, forKey: KEY_SUNSET_TIME)
        }
        
    }
    
    //MARK: - Helper functions
    
    func fillDailyDataWeather(dailyDataWeather: Dictionary<String, AnyObject>) {
        
        _day = Utils.getOptionalDoubleFromDictionary(KEY_TIME, dict: dailyDataWeather)
        _minTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE_MIN, dict: dailyDataWeather)
        _maxTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE_MAX, dict: dailyDataWeather)
        _icon = Utils.getOptionalStringFromDictionary(KEY_ICON, dict: dailyDataWeather)
        _sunriseTime = Utils.getOptionalIntFromDictionary(KEY_SUNRISE_TIME, dict: dailyDataWeather)
        _sunsetTime = Utils.getOptionalIntFromDictionary(KEY_SUNSET_TIME, dict: dailyDataWeather)
        
    }
    
}