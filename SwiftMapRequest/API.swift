//
//  API.swift
//  SwiftMapRequest
//
//  Created by Ленар on 25.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

class API {
    
    static let sharedInstance = API()
    
    let googleApiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAIPGNUQscK8v_9DH19hOgM_voyFiks6go&language=ru&radius=50000&types=(art_gallery|point_of_interest|church|city_hall|hindu_temple|mosque|movie_theater|museum|painter|park|place_of_worship|rv_park)&location="
    
    func artworkFor(lat:Double, lng:Double) {
        let strURL = googleApiURL+"\(lat),\(lng)"
        self.setRequest(strURL)
    }
    
    func setRequest(_ strUrl:String) {
        let url = URL(string:strUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data,request,error in
            if(error != nil){
                print(error?.localizedDescription ?? "Undeclared Error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    print(json)
                }catch let error as NSError{
                    print(error)
                }
            }
        }.resume()
    }
}
