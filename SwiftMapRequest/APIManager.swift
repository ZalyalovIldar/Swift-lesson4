//
//  API.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit

protocol UpdateDataDeligate {
    func updateMapInfo(cityName:String, cityCoordinate:CLLocationCoordinate2D,artworks:[Artwork])
}

class APIManager {
    
    var delegate:UpdateDataDeligate!
    
    let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let key = "AIzaSyAIPGNUQscK8v_9DH19hOgM_voyFiks6go"
    
    let googleApiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBxgfC_wz5EuyEnYmL2_8VcIJ-Amqo61Go&language=ru&radius=500000&types=art_gallery&location="
    
    func artworkFor(cityName:String, cityCoordinate:CLLocationCoordinate2D){
        let strURL = baseURL + "key=\(key)" + "&language=ru" + "&radius=500000" + "&types=art_gallery" + "&location=\(cityCoordinate.latitude),\(cityCoordinate.longitude)"
        self.setRequest(cityName,cityCoordinate,strURL)
    }
    
    func setRequest(_ cityName:String,_ cityCoordinate:CLLocationCoordinate2D,_ strUrl:String) {
        let url = URL(string:strUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data,request,error in
            if(error != nil){
                print(error?.localizedDescription ?? "Undeclared Error")
            }else{
                do{
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject]
                    let arr = JSONManager.getArtworksArray(from: jsonDict!)
                    DispatchQueue.main.async {
                        self.delegate.updateMapInfo(cityName: cityName,cityCoordinate: cityCoordinate,artworks: arr)
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }.resume()
    }
}
