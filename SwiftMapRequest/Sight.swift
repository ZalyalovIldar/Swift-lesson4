//
//  Sight.swift
//  SwiftMapRequest
//
//  Created by Наталья on 05.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit
//
//struct Coordinate2D{
//    var latitude: Double = 0
//    var longtitude: Double = 0
//}

class Sight:NSObject, MKAnnotation {
    
    
    let coordinate: CLLocationCoordinate2D
    let title:String?
    let locationName:String
    

    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
       
        
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }






}
