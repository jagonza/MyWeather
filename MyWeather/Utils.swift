//
//  Utils.swift
//  MyWeather
//
//  Created by Javier González Rojo on 4/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation


class Utils {

    static func getStringHoursFromMillis(timeInMillis: Int) -> String {
        
        let timeInterval = NSTimeInterval(integerLiteral: Int64(timeInMillis))
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func getDateStringFromTimeInterval(timeInterval: NSTimeInterval, mask: String) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = mask
        
        return dateFormatter.stringFromDate(date)
    }
    
    
    static func storeWeatherIntoUserDefaults(latitude: String, longitude: String, weather: Weather) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(weather), forKey: "\(latitude)#\(longitude)")
        
    }
    
    static func getWeatherFromUserDefaults(latitude: String, longitude: String) -> Weather? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey("\(latitude)#\(longitude)") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Weather
        } else {
            return nil
        }
        
    }
    
    
    static func downloadLastWeatherInfo(lastWeatherNSTimeInterval: NSTimeInterval) -> Bool {
        
        let now = NSDate().timeIntervalSince1970
        
        if now - lastWeatherNSTimeInterval > CT_SECONDS_TO_UPDATE {
            return true
        } else {
            return false
        }
        
    }
    
    static func getOptionalStringFromDictionary(key: String, dict: Dictionary<String, AnyObject>) -> String? {
        if let value = dict[key] as? String {
            return value
        } else {
            return nil
        }
    }
    
    static func getOptionalDoubleFromDictionary(key: String, dict: Dictionary<String, AnyObject>) -> Double? {
        
        if let value = dict[key] as? Double {
            return value
        } else {
            return nil
        }
        
    }
    
}