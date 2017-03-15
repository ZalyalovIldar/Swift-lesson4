//
//  ViewController.swift
//  SwiftMapRequest
//
//  Created by Ildar Zalyalov on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class ViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet var viewController: UIView!
    let apiManager = APIManager()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        createLocation()
        mapView.showsUserLocation = true;
        mapView.delegate = self
    }
    
    @IBAction func showSearchBar(_ sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

}

