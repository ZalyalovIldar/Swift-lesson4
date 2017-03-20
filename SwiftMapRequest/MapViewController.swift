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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Создание экземпляра TableView программным путем
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
        definesPresentationContext = true//указывает на модальное наложение
        
        locationSearchTable.mapView = mapView
        
        //----------------------------------------
        
        
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

