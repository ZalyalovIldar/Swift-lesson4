//
//  ViewController.swift
//  SwiftMapRequest
//
//  Created by Ildar Zalyalov on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa
import ReactiveSwift
import Result
import AddressBook

class ViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet var viewController: UIView!
    let apiManager = APIManager()
    var searchController = UISearchController()
    let viewModel: MapViewModelTypes = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        createLocation()
        mapView.showsUserLocation = true;
        mapView.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }
    
    func bindViewModel() {
        searchController.searchBar.reactive.continuousTextValues.signal.skipNil().observeValues { (value) in
            self.viewModel.inputs.searchTextChanged(value)
        }
        
        self.viewModel.outputs.currentLocation.observeValues { (location) in
            let pointAnnotation = MKPointAnnotation()
            
            if self.mapView.annotations.count != 0 {
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
            }
            
            pointAnnotation.coordinate = location.coordinate
            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegionMake(pointAnnotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(pointAnnotation)
        }
        
        self.viewModel.outputs.sightsCoordinates.observeValues { (sights) in
            var annotations = [SightAnnotation]()
            
            for sight in sights {
                let sightAnnotation = SightAnnotation(sight: sight)
                annotations.append(sightAnnotation)
            }
            self.mapView.addAnnotations(annotations)
        }
        
        
    }
    
    @IBAction func showSearchBar(_ sender: AnyObject) {
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

}

//MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func createLocation(){
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }

        
    }
    
}

//MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    //MARK: Pin in Map View
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? SightAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let infoButton = UIButton.init(type: .detailDisclosure)
                infoButton.addTarget(self, action: #selector(infoButtonDidClicked(sender:)), for: .touchUpInside)
                view.rightCalloutAccessoryView = infoButton as UIView
                
            }
            return view
        }
        return nil
    }
    
    
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func infoButtonDidClicked(sender: Any) {
        //Nothing to show now
    }
    
    func showSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchButtonPressed()
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

}



