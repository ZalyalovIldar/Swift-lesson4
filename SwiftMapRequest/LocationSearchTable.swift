//
//  LocationSearchTable.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class LocationSearchTable: UITableViewController {
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    let realm = try! Realm()
    lazy var cities:Results<City> = { self.realm.objects(City.self) }()
    var city:City? {
        return cities.last
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        self.tableView.reloadData()
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

//MARK: Search Table
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if city != nil {
            return matchingItems.count + 1
        }else {
            return matchingItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if city == nil {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
            return cell
        }
        if indexPath.row == 0 {
            let city:City = cities.last!
            cell.textLabel?.text = city.name
            cell.imageView?.image = UIImage(named: "Watch")
            cell.detailTextLabel?.text = city.region
            return cell
        }
        let selectedItem = matchingItems[indexPath.row-1].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if city != nil {
            if indexPath.row == 0 {
                let city:City = cities.last!
                self.handleMapSearchDelegate?.setPinsSavedArtworks(inCity: city)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        var selectedItem:MKPlacemark
        if city != nil {
            selectedItem = matchingItems[indexPath.row-1].placemark
        }else {
            selectedItem = matchingItems[indexPath.row].placemark
        }
        self.handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        self.dismiss(animated: true, completion: nil)
    }
}

