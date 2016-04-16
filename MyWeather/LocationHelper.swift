//
//  LocationHelper.swift
//  MyWeather
//
//  Created by Javier González Rojo on 14/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper {
    
    static func getLocationNameFromCoordinates(latitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: (name: String) -> Void) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
    
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            print(placeMark.addressDictionary)
            
            if let sublocality = placeMark.addressDictionary!["SubLocality"] as? String {
                completion(name: sublocality)
            } else {
                completion(name: "")
            }
            
        })
    
    }
    
    
}