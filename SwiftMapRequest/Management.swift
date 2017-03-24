//
//  Management.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 23.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//


import MapKit
import UIKit
import RealmSwift

class Management: NSObject {
    let realm = try! Realm()
    
    func saveCityWithAttractionOnRealm(city: City, attractionsArr: [Attraction]) {
        for attraction in attractionsArr{
            city.attractions.append(attraction)
        }
        let lists = realm.objects(City.self)
        try! realm.write {
            if lists.count > 1 {
                realm.delete(lists[0])
            }
            realm.add(city)
        }
        
    }
    
    func getNeededCityAndAttractionsFromRealm() -> City {
        let lists = realm.objects(City.self)
        return lists[0]
    }
    
}
