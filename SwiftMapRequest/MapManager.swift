//
//  MapManager.swift
//  SwiftMapRequest
//
//  Created by Наталья on 07.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import AddressBook
import MapKit


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
            
            apiManager.sightCoordinates(near: location, successBlock: { (result:[Sight]) in
                
                self.mapView.addAnnotations(result)
              
            })
        }
        
    }
    
}


extension ViewController: MKMapViewDelegate,UISearchBarDelegate {
  
//MARK: Pin in Map View
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Sight {
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
    
    
//MARK: Search Bar
    
    func infoButtonDidClicked(sender: Any) {
        //Nothing to show now
    }
    
    func showSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
        }

        self.apiManager.geocodeCity(cityName: searchBar.text!, successBlock: { (result:CLLocationCoordinate2D?) in
            
            guard let result = result else {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
           
            let coordinates = CLLocation(latitude: result.latitude, longitude: result.longitude)
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: result.latitude, longitude:result.longitude)
            
            

            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegionMake(pointAnnotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(pointAnnotation)
            
            
            self.apiManager.sightCoordinates(near: coordinates as CLLocation, successBlock: { (result:[Sight]) in
                self.mapView.addAnnotations(result)
            })
        })
    }
}



