//
//  Attraction.swift
//  SwiftMapRequest
//
//  Created by Ilyas on 20.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//
import Foundation
import MapKit
import Contacts

class Attraction:NSObject {
    
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

//MARK: - MapKit related methods
extension Attraction: MKAnnotation {
    
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
