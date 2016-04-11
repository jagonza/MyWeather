//
//  HourlyWeather.swift
//  MyWeather
//
//  Created by Javier González Rojo on 10/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation


class HourlyWeather:NSObject, NSCoding {

    private var _time: NSTimeInterval?
    private var _temperature: Double?
    private var _icon: String?
    private var _precProb: Double?
    
    var time: NSTimeInterval {
        if _time == nil {
            return NSDate().timeIntervalSince1970
        } else {
            return NSTimeInterval(_time!)
        }
    }
    
    var temperature: String {
        if _temperature == nil {
            return ""
        } else {
            return "\(Int(_temperature!))º"
        }
    }
    
    var icon: String {
        if _icon == nil {
            return ""
        } else {
            return _icon!
        }
    }
    

    var precipProb: String {
        if _precProb == nil {
            return ""
        } else {
            return "\(Int(_precProb! * 100))%"
        }
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let time = aDecoder.decodeObjectForKey(KEY_TIME) as? Double {
            _time = time
        }
        
        if let temp = aDecoder.decodeObjectForKey(KEY_TEMPERATURE) as? Double {
            _temperature = temp
        }
        
        if let icon = aDecoder.decodeObjectForKey(KEY_ICON) as? String {
            _icon = icon
        }
        
        if let precProb = aDecoder.decodeObjectForKey(KEY_PRECIP_PROBABILITY) as? Double {
            _precProb = precProb
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let time = _time {
            aCoder.encodeObject(time, forKey: KEY_TIME)
        }
        
        if let temp = _temperature {
            aCoder.encodeObject(temp, forKey: KEY_TEMPERATURE)
        }
        
        if let icon = _icon {
            aCoder.encodeObject(icon, forKey: KEY_ICON)
        }
        
        if let precProb = _precProb {
            aCoder.encodeObject(precProb, forKey: KEY_PRECIP_PROBABILITY)
        }
        
    }
    
    func fillHourlyDataWeather(hourlyWeather: Dictionary<String, AnyObject>) {
        
        _time = Utils.getOptionalDoubleFromDictionary(KEY_TIME, dict: hourlyWeather)
        _temperature = Utils.getOptionalDoubleFromDictionary(KEY_TEMPERATURE, dict: hourlyWeather)
        _icon = Utils.getOptionalStringFromDictionary(KEY_ICON, dict: hourlyWeather)
        _precProb = Utils.getOptionalDoubleFromDictionary(KEY_PRECIP_PROBABILITY, dict: hourlyWeather)
        
    }
    
    
    
}