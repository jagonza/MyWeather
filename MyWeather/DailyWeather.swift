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
        
        
    }
    
    //MARK: - Helper functions
    
    func fillDailyDataWeather(dailyDataWeather: Dictionary<String, AnyObject>) {
        
        _day = Utils.getOptionalDoubleFromDictionary(KEY_TIME, dict: dailyDataWeather)
        _minTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE_MIN, dict: dailyDataWeather)
        _maxTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE_MAX, dict: dailyDataWeather)
        _icon = Utils.getOptionalStringFromDictionary(KEY_ICON, dict: dailyDataWeather)
        
    }
    
}