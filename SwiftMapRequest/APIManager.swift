//
//  API.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

protocol UpdateDataDeligate {
    func updateMapInfo(artworks:[Artwork])
}

class APIManager {
    
    var deligate:UpdateDataDeligate!
    
    let googleApiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAIPGNUQscK8v_9DH19hOgM_voyFiks6go&language=ru&radius=500000&types=art_gallery&location="
    
    func artworkFor(lat:Double, lng:Double){
        let strURL = googleApiURL+"\(lat),\(lng)"
        self.setRequest(strURL)
    }
    
    func setRequest(_ strUrl:String) {
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
                        self.deligate.updateMapInfo(artworks: arr)
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }.resume()
    }
}
