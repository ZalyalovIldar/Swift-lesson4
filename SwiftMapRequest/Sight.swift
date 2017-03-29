//
//  Sight.swift
//  SwiftMapRequest
//
//  Created by Наталья on 05.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

import RealmSwift
import CoreLocation



class Sight: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var coordinate: Coordinate? = Coordinate(latitude: 0.0, longtitude: 0.0)
    dynamic var name: String = ""
    dynamic var address: String = ""
    
    
    convenience init(coreCoordinate: CLLocationCoordinate2D, name: String, address: String) {
        self.init()
        self.coordinate = Coordinate.init(coordinate: coreCoordinate)
        self.name = name
        self.address = address
        
    }
    
    convenience init(coordinate: Coordinate, name: String, address: String) {
        self.init()
        self.coordinate = coordinate
        self.name = name
        self.address = address
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    

}
