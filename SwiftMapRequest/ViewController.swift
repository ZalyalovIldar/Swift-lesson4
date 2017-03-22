//
//  ViewController.swift
//  SwiftMapRequest
//
//  Created by Ildar Zalyalov on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
    func setPinsSavedArtworks(inCity city:City)
}

class ViewController: UIViewController {

    let apiManager = APIManager()
    var resultSearchController:UISearchController? = nil
    let locationManager = CLLocationManager()
    let realm = try! Realm()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var userLocationButton: MKUserTrackingBarButtonItem! {
        didSet {
            userLocationButton.mapView = self.mapView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.apiManager.delegate = self
        
        self.configureMap()
        self.initSearchController()
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        if (currentLocation.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            let coords = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            self.centerMapOnLocation(coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't get location")
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}

//MARK: Search protocol extension
extension ViewController: HandleMapSearch {
    func setPinsSavedArtworks(inCity city: City) {
        let annotations:[Artwork] = Array(city.artworks)
        self.mapView.addAnnotations(annotations)
        let location:CLLocation = CLLocation(latitude: city.coordinate.latitude, longitude: city.coordinate.longitude)
        self.centerMapOnLocation(location)
    }

    func dropPinZoomIn(placemark:MKPlacemark){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        self.apiManager.artworkFor(cityName:placemark.locality ?? "City", cityRegion:placemark.administrativeArea ?? "Region",cityCoordinate:annotation.coordinate)
    }
}
//MARK: MapKit
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "artPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = annotation.setPinTintColor()
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location:Artwork = view.annotation as! Artwork? else {return}
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.createMapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

//MARK: Helper
extension ViewController: UpdateDataDeligate {
    func configureMap() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
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
    func updateMapInfo(cityName:String, cityRegion:String, cityCoordinate:CLLocationCoordinate2D,artworks: [Artwork]) {
        try! realm.write{
            let city = City()
            city.name = cityName
            city.region = cityRegion
            city.lat = cityCoordinate.latitude
            city.lng = cityCoordinate.longitude
            city.artworks = List(artworks)
            self.realm.add(city)
        }
        self.mapView.addAnnotations(artworks)
    }
}


