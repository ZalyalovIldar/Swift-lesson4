//
//  City.swift
//  SwiftMapRequest
//
//  Created by Наталья on 22.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var coordinate: Coordinate? = Coordinate(latitude: 0.0, longtitude: 0.0)
    let sights = List<Sight>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
