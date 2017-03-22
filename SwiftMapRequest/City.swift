//
//  City.swift
//  SwiftMapRequest
//
//  Created by Ленар on 20.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class City:Object {
    dynamic var name:String = ""
    dynamic var lat:Double = 0.0
    dynamic var lng:Double = 0.0
    var artworks = List<Artwork>()
}
