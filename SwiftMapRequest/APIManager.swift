//
//  APIManager.swift
//  SwiftMapRequest
//
//  Created by Наталья on 01.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class APIManager {
    
//    let APIKey = "AIzaSyDh-HM0OyZpjNW9k7vMXLH1hwij32ByMC0"
    private let googleSightURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDh-HM0OyZpjNW9k7vMXLH1hwij32ByMC0&radius=20000&types=zoo|museum|park|movie_theater|art_gallery|painter&location="
    private let googleGeocodeURL = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDh-HM0OyZpjNW9k7vMXLH1hwij32ByMC0&address="

    
    
    func sightCoordinates(near location:CLLocation, successBlock:@escaping (_ result:[Sight]) -> ()) {
        let fullURL = (googleSightURL) + "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let correctUrl = fullURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: correctUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
            }else {
               let sights = self.parseSightsResponse(data: data)
                DispatchQueue.main.async {
                    successBlock(sights)
                }
                
            }
        }.resume()
    }
    
    func geocodeCity(cityName:String, successBlock:@escaping (_ result:CLLocationCoordinate2D?) -> ()){
        let fullUrl = (googleGeocodeURL) + "\(cityName)"
        let correctURL = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: correctURL)
        var  request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
            }else {
                let location = self.parseCityResponse(data: data)
                
                
                DispatchQueue.main.async {
                    successBlock(location)
                }
                
            }
            }.resume()
    }
    
    
//MARK: Parsers
    
    func parseCityResponse(data:Data?) -> CLLocationCoordinate2D? {
        var coordinates:CLLocationCoordinate2D?
        
        do{
            if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String:Any],
                let results = json["results"] as? [[String:Any]] {
                
                for result in results {
                    
                    if let geometry = result["geometry"] as? [String:Any],
                        let location = geometry["location"] as? [String:Any]{
                        if let latitude = location["lat"] as? Double,
                            let longitude = location["lng"] as? Double {
                            coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        }
                    }
                }
                
            }
        }catch let error as NSError {
            print(error)
        }
        return coordinates
    }
    
    
    func parseSightsResponse(data:Data?) -> [Sight] {
        var sights = [Sight]()
        do {
            if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String:Any],
                let results = json["results"] as? [[String:Any]] {
                
                for result in results {
                    var sightName:String?
                    var coordinate:CLLocationCoordinate2D?
                    var address:String?
                    if let name = result["name"] as? String {
                        sightName = name
                    }
                    if let vicinity = result["vicinity"] as? String{
                        address = vicinity
                        
                    }
                    if let geometry = result["geometry"] as? [String:Any],
                        let location = geometry["location"] as? [String:Any] {
                        if let latitude = location["lat"] as? Double,
                            let longitude = location["lng"] as? Double{
                            
                            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            
                        }
                    }
                    let sight = Sight(title: sightName!, locationName: address!, coordinate: coordinate!)
                    sights.append(sight)
                }
            }
        }catch let error as NSError {
            print(error)
        }
        return sights
    }

   
    
}
