//
//  SightAnnotation.swift
//  SwiftMapRequest
//
//  Created by Наталья on 22.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit
class SightAnnotation: NSObject, MKAnnotation {
    var sight: Sight?
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var title: String?
    var subtitle: String?
    
    convenience init(sight: Sight) {
        
        self.init()
        self.sight = sight
        
        self.coordinate = CLLocationCoordinate2D.init(latitude: (sight.coordinate?.latitude)!, longitude: (sight.coordinate?.longtitude)!)
        
        self.title = sight.name
        self.subtitle = sight.address
        
    }
    
    override init() {
        super.init()
    }
}
