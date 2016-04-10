//
//  CurrentWeather.swift
//  MyWeather
//
//  Created by Javier González Rojo on 3/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather: NSObject, NSCoding {
    
    //MARK: - Global variables
        
    private var _icon: String?
    private var _currentTemp: Double?
    private var _apparentTemp: Double?
    private var _precipProb: Double?
    private var _sunriseTime: Int?
    private var _sunsetTime: Int?
    
    
    //MARK: - Public variables
    
    var icon: String {
        if _icon == nil {
            return ""
        } else {
            return _icon!
        }
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            return ""
        } else {
            return "\(Int(_currentTemp!))º"
        }
    }
    
    var apparentTemp: String {
        if _apparentTemp == nil {
            return ""
        } else {
            return "\(Int(_apparentTemp!))º"
        }
    }

    var precipProb: String {
        if _precipProb == nil {
            return ""
        } else {
            return "\(Int(_precipProb! * 100))%"
        }
    }
    
    var sunriseTime: String {
        if _sunriseTime == nil {
            return ""
        } else {
            return Utils.getStringHoursFromMillis(_sunriseTime!)
        }
    }
    
    var sunsetTime: String {
        if _sunsetTime == nil {
            return ""
        } else {
            return Utils.getStringHoursFromMillis(_sunsetTime!)
        }
    }
    
    //MARK: - Initializers
    
    override init() {
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let icon = aDecoder.decodeObjectForKey(KEY_ICON) as? String{
            _icon = icon
        }
        
        if let currentTemp = aDecoder.decodeObjectForKey(KEY_TEMPERATURE) as? Double {
            _currentTemp = currentTemp
        }
        
        if let apparentTemp = aDecoder.decodeObjectForKey(KEY_APPARENT_TEMPERATURE) as? Double {
            _apparentTemp = apparentTemp
        }
        
        if let precipProb = aDecoder.decodeObjectForKey(KEY_PRECIP_PROBABILITY) as? Double {
            _precipProb = precipProb
        }
        
    }
    

    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let icon = _icon {
            aCoder.encodeObject(icon, forKey: KEY_ICON)
        }
        
        if let currentTemp = _currentTemp {
            aCoder.encodeObject(currentTemp, forKey: KEY_TEMPERATURE)
        }
        
        if let apparentTemp = _apparentTemp {
            aCoder.encodeObject(apparentTemp, forKey: KEY_APPARENT_TEMPERATURE)
        }
        
        if let precipProb = _precipProb {
            aCoder.encodeObject(precipProb, forKey: KEY_PRECIP_PROBABILITY)
        }
        
    }
    
    //MARK: - Helper functions
    
    func fillCurrentWeatherInfo(currentWeather: Dictionary<String, AnyObject>) {
        
        _icon = Utils.getOptionalStringFromDictionary(KEY_ICON, dict: currentWeather)
        _currentTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE, dict: currentWeather)
        _apparentTemp = Utils.getOptionalDoubleFromDictionary(KEY_APPARENT_TEMPERATURE, dict: currentWeather)
        _precipProb = Utils.getOptionalDoubleFromDictionary(KEY_PRECIP_PROBABILITY, dict: currentWeather)
        
    }
    
    
    
}