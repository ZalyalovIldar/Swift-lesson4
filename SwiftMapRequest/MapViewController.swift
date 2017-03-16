//
//  ViewController.swift
//  SwiftMapRequest
//
//  Created by Ildar Zalyalov on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchField: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionalRadius : CLLocationDistance = 1000
        
        func centerMapLocation(location : CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionalRadius * 2.0, regionalRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapLocation(location: initialLocation)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

