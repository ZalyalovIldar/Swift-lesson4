//
//  LocationSearchTable.swift
//  SwiftMapRequest
//
//  Created by Ilyas on 20.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        
    }
}
