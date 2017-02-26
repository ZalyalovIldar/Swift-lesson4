//
//  Extentions.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//MARK: Helper
extension ViewController: UpdateDataDeligate {
    func configureMap() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.apiManager.artworkFor(lat: (self.locationManager.location?.coordinate.latitude)!, lng: (self.locationManager.location?.coordinate.longitude)!)
    }
    
    func initSearchController () {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        self.navigationItem.titleView = resultSearchController?.searchBar
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    //MARK: Download data from API and set pin in map view
    func updateMapInfo(artworks: [Artwork]) {
        self.mapView.addAnnotations(artworks)
    }
}
