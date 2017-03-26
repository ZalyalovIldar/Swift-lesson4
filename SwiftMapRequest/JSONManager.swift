//
//  JSONManager.swift
//  SwiftMapRequest
//
//  Created by Ilyas on 20.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import CoreLocation

class JSONManager {
    class func getAttractionArray(from jsonDictinary:[String:Any]) -> [Attraction] {
        var attractions = [Attraction]()
        let resultArray = jsonDictinary["results"] as! [Any]
        for infoDict in resultArray {
            let results = infoDict as! [String:Any]
            let title = results["name"] as! String
            let locationName = results["vicinity"] as! String
            let geometry = results["geometry"] as! [String:Any]
            let location = geometry["location"] as! [String:Double]
                let lat = location["lat"]! as Double
                let lng = location["lng"]! as Double
            let attraction = Attraction(title: title, locationName: locationName, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            attractions.append(attraction)
        }
        return attractions
    }
}
