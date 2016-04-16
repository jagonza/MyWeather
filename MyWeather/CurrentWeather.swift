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
    private var _summary: String?
    
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
    
    var summary: String {
        if _summary == nil {
            return ""
        } else {
            return _summary!
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
        
        if let summary = aDecoder.decodeObjectForKey(KEY_CURRENT_SUMMARY) as? String{
            _summary = summary
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
        
        if let summary = _summary {
            aCoder.encodeObject(summary, forKey: KEY_CURRENT_SUMMARY)
        }
        
    }
    
    //MARK: - Helper functions
    
    func fillCurrentWeatherInfo(currentWeather: Dictionary<String, AnyObject>) {
        
        _icon = Utils.getOptionalStringFromDictionary(KEY_ICON, dict: currentWeather)
        _currentTemp = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE, dict: currentWeather)
        _apparentTemp = Utils.getOptionalDoubleFromDictionary(KEY_APPARENT_TEMPERATURE, dict: currentWeather)
        _precipProb = Utils.getOptionalDoubleFromDictionary(KEY_PRECIP_PROBABILITY, dict: currentWeather)
        _summary = Utils.getOptionalStringFromDictionary(KEY_SUMMARY, dict: currentWeather)
        
    }
    
    
    
}