//
//  Coordinate.swift
//  SwiftMapRequest
//
//  Created by Наталья on 22.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Coordinate: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longtitude: Double = 0.0
    
    convenience init (latitude: Double, longtitude: Double) {
        self.init()
        self.latitude = latitude
        self.longtitude = longtitude
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.latitude = coordinate.latitude
        self.longtitude = coordinate.longitude
    }
}
