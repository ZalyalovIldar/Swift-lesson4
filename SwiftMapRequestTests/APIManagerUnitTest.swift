//
//  APIManagerUnitTest.swift
//  SwiftMapRequest
//
//  Created by Наталья on 28.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import XCTest
import CoreLocation.CLLocation
@testable import SwiftMapRequest

class APIManagerUnitTest: XCTestCase {
    var apiManager: APIManager!
    override func setUp() {
        super.setUp()
        apiManager = APIManager()
    }
    
    override func tearDown() {
        apiManager = nil
        super.tearDown()
    }
    
  
    func testGeocodedCityNotNil(){
        let expect = expectation(description: "getGeocodedCityExpect")
        let cityName = "Moscow"
        
        apiManager.geocodeCity(cityName: cityName) { (location) in
            if location != nil {
                XCTAssert(true)
            }else{
                XCTFail("location is nil")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error) in
            if let lError = error{
                XCTFail("Error: \(lError.localizedDescription)")
            }
        }
    }

    func testSightCoordinatesNotNil(){
        let expect = expectation(description: "getSightCoordinatedExpect")
        let location = CLLocation(latitude: 55.7919 , longitude: 49.1272 )
       
        apiManager.sightCoordinates(near: location) { (result : [Sight]) in
            if result.count != 0 {
                XCTAssertTrue(true)
            }else{
                XCTFail("Sights are empty")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error) in
            if let lError = error{
                XCTFail("Error: \(lError.localizedDescription)")
            }
        }

    }
    
}
