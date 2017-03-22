//
//  MapViewModel.swift
//  SwiftMapRequest
//
//  Created by Наталья on 21.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import CoreLocation.CLLocation
import RealmSwift

protocol MapViewModelInputs {
    ///Call whevarearch text changed
    func searchTextChanged(_ text: String)
    
    ///Call when search button pressed
    func searchButtonPressed()
    
    ///Call when location changed
    func locationChanged(location: CLLocation)
    
    ///Call when view will appear
    func viewWillAppear()
}

protocol MapViewModelOutputs {
    ///Emits when current location changed
    var currentLocation: Signal<CLLocation, NoError> { get }
    
    var sightsCoordinates: Signal<[Sight], NoError> { get }
    
    //// Emits when a location search error has occurred and a message should be displayed
    var showError: Signal<String, NoError> { get }

}

protocol MapViewModelTypes {
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
    
}



class MapViewModel: MapViewModelInputs, MapViewModelOutputs, MapViewModelTypes {
    
    init() {
        self.currentLocation = self.currentLocationProperty.signal.skipNil()
        self.showError = self.showErrorMutableProperty.signal.skipNil()
        self.sightsCoordinates = self.sightsCoordinatesProperty.signal.skipNil()
        
    }
    
    public var inputs: MapViewModelInputs { return self }
    public var outputs: MapViewModelOutputs { return self }
    
    //MARK: inputs
    fileprivate let searchTextChangedProperty = MutableProperty<String?>(nil)
    func searchTextChanged(_ text: String) {
        searchTextChangedProperty.value = text
    }
    
    
    func searchButtonPressed() {
        
        if let value = searchTextChangedProperty.value {
            APIManager().geocodeCity(cityName: value, successBlock: { (coordinates) in
                guard let coordinates = coordinates else {
                    self.showErrorMutableProperty.value = "Can't find city"
                    return
                }
                
                let location = CLLocation.init(latitude: coordinates.latitude, longitude: coordinates.longitude)

                self.currentLocationProperty.value = location
                APIManager().sightCoordinates(near: location, successBlock: { (sights : [Sight]) in
                    self.sightsCoordinatesProperty.value = sights
                    let city = City()
                    city.sights.append(objectsIn: sights)
                    city.name = value
                    city.coordinate = Coordinate(coordinate: coordinates)
                    
                    
                    let realm = try! Realm()
                    let readedCity: City? = realm.objects(City.self).first
                    
                    try! realm.write {
                        if readedCity != nil {
                            city.id = readedCity!.id
                            realm.add(city, update: true)
                        }else {
                            realm.create(City.self, value: city, update: true)
                        }
                    }
                })
                
            })
        }

        
    }
    
    fileprivate let locationChangedProperty = MutableProperty<CLLocation?> (nil)
    func locationChanged(location: CLLocation) {
        locationChangedProperty.value = location
    }
    
    func viewWillAppear() {
        let realm = try! Realm()
        let city: City? = try! realm.objects(City).first
        
        if let city = city {
            let location = CLLocation(latitude: (city.coordinate?.latitude)!, longitude: (city.coordinate?.longtitude)!)
            currentLocationProperty.value = location
            
            var sights = [Sight]()
            for sight in city.sights {
                sights.append(sight)
            }
            sightsCoordinatesProperty.value = sights
        }
       
    }
    
    //MARK: outputs
    
    fileprivate let sightsCoordinatesProperty = MutableProperty<[Sight]?>(nil)
    public let sightsCoordinates: Signal<[Sight], NoError>;
    
    fileprivate let currentLocationProperty = MutableProperty<CLLocation?> (nil)
    public let currentLocation: Signal<CLLocation, NoError>
    
    fileprivate let showErrorMutableProperty = MutableProperty<String?> (nil)
    public let showError: Signal<String, NoError>
    
    
    
    
    
}
