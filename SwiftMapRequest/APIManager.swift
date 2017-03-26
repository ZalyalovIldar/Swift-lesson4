//
//  APIManager.swift
//  SwiftMapRequest
//
//  Created by Ilyas on 16.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

protocol UpdateDataDeligate {
        func updateMapInfo(attractions:[Attraction])
    }

class APIManager{
    
    var delegate: UpdateDataDeligate!
    
    let standartURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let key = "AIzaSyB7BvzwLpqOxr5NAIF0ojjIhQK5ruLyNNU"
    
    func attractionFor(lat:Double, lng:Double) {
        let strURL = standartURL + "key=\(key)" + "&language=ru" + "&radius=500000" + "&types=art_gallery" + "&location=\(lat),\(lng)"
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
                    let arr = JSONManager.getAttractionArray(from: jsonDict!)
                    DispatchQueue.main.async {
                        self.delegate.updateMapInfo(attractions: arr)
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
            }.resume()
    }

}
