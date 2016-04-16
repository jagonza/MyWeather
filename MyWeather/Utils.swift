//
//  Utils.swift
//  MyWeather
//
//  Created by Javier González Rojo on 4/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation


class Utils {

    static func getStringHoursFromSeconds(timeInSeconds: Int) -> String {
        
        let timeInterval = NSTimeInterval(integerLiteral: Int64(timeInSeconds))
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func getDateStringFromTimeInterval(timeInterval: NSTimeInterval, mask: String) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = mask
        
        return dateFormatter.stringFromDate(date)
    }
    
    
    static func storeWeatherIntoUserDefaults(latitude latitude: Double, longitude: Double, weather: Weather) {
        
        let strLat = Utils.doubleToString(latitude, decimals: 3)
        let strLong = Utils.doubleToString(longitude, decimals: 3)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(weather), forKey: "\(strLat)#\(strLong)")
        
    }
    
    static func getWeatherFromUserDefaults(latitude latitude: Double, longitude: Double) -> Weather? {
        
        let strLat = Utils.doubleToString(latitude, decimals: 3)
        let strLong = Utils.doubleToString(longitude, decimals: 3)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey("\(strLat)#\(strLong)") as? NSData {
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
    
    static func getOptionalIntFromDictionary(key: String, dict: Dictionary<String, AnyObject>) -> Int? {
        if let value = dict[key] as? Int {
            return value
        } else {
            return nil
        }
    }
    
    
    static func doubleToString(double: Double, decimals: Int) -> String {
        let fmt = NSNumberFormatter()
        fmt.minimumFractionDigits = decimals
        return fmt.stringFromNumber(double)!
    }
    
}