//
//  JSONManger.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import CoreLocation

class JSONManager {
    class func getArtworksArray(from jsonDictinary:[String:Any]) -> [Artwork] {
        var artworks = [Artwork]()
        let resultArray = jsonDictinary["results"] as! [Any]
        for infoDict in resultArray {
            let results = infoDict as! [String:Any]
            let title = results["name"] as! String
            let locationName = results["vicinity"] as! String
            let geometry = results["geometry"] as! [String:Any]
            let location = geometry["location"] as! [String:Double]
            let lat = location["lat"]! as Double
            let lng = location["lng"]! as Double
            let artwork = Artwork()
            artwork.title = title
            artwork.locationName = locationName
            artwork.lat = lat
            artwork.lng = lng
            //artwork.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            artworks.append(artwork)
        }
        return artworks
    }
}
