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
    
    var resultSearchController : UISearchController? = nil
    var selectedPin : MKPlacemark? = nil
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Создание экземпляра TableView
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //создание поисковой строки в навигационном контроллере
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Article for place"
        navigationItem.titleView = resultSearchController?.searchBar
        
        //настройки для поисковой строки
        resultSearchController?.hidesNavigationBarDuringPresentation = false//исчезает ли панель навигации6 когда показаны результаты
        resultSearchController?.dimsBackgroundDuringPresentation = true//полупрозрачный фон при выборе панели поиска
        definesPresentationContext = true //указывает на модальное наложение
        
        locationSearchTable.mapView = mapView
        
        //----------------------------------------
        locationSearchTable.handleMapSearchDelegate = self
        self.apiManager.delegate = self
        
        
    }
}

protocol HadleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension ViewController: HadleMapSearch{
    internal func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        self.apiManager.attractionFor(lat: placemark.coordinate.latitude, lng: placemark.coordinate.longitude)
    }
}

extension ViewController: UpdateDataDeligate{
    func updateMapInfo(attractions: [Attraction]) {
        self.mapView.addAnnotations(attractions)
    }
}

