//
//  HTTPRequest.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 08.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation


class HTTPRequest {
    class func httpRequest(cordinate: CordinateWithRadiuSstruct) -> Data?{
        let key = "AIzaSyBxgfC_wz5EuyEnYmL2_8VcIJ-Amqo61Go"
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(cordinate.latitude),\(cordinate.longitude)&radius=\(cordinate.radius)&types=point_of_interest&key=\(key)"
        var dataResult: Data? = nil
        let encodingUrl = URL(string: urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
        let semaphore = DispatchSemaphore(value: 0)
        if let url = encodingUrl {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard  error == nil else { semaphore.signal();  return }
                dataResult = data
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: .distantFuture)
        }
        return dataResult
    }
}


