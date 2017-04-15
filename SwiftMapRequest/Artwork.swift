//
//  AttractionModel.swift
//  SwiftMapRequest
//
//  Created by Ленар on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit
import Contacts
import RealmSwift

class Artwork:Object {
    
    dynamic var title: String? = ""
    dynamic var locationName: String = ""
    dynamic var lat:Double = 0.0
    dynamic var lng:Double = 0.0
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    dynamic var subtitle: String? {
        return locationName
    }
}

//MARK: - MapKit related methods
extension Artwork: MKAnnotation {
    
    func setPinTintColor() -> UIColor {
        return MKPinAnnotationView.purplePinColor()
    }
    
    func createMapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
