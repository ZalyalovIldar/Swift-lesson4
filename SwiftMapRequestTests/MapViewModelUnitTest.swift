//
//  MapViewModelUnitTest.swift
//  SwiftMapRequest
//
//  Created by Наталья on 28.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import XCTest
@testable import ReactiveSwift
@testable import Result

import CoreLocation.CLLocation

@testable import SwiftMapRequest


class MapViewModelUnitTest: XCTestCase {
    fileprivate let vm:MapViewModelTypes = MapViewModel()
    
  

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
       
        super.tearDown()
    }
    
    func testCurrentLocationExpected() {
        let expect = expectation(description: "Expect")
        vm.outputs.currentLocation.observeValues { (location) in
            if location != nil {
                XCTAssert(true)
            }else {
                XCTFail("location is nil")
            }
            expect.fulfill()
        }
        vm.inputs.searchTextChanged("Kazan")
        vm.inputs.searchButtonPressed()
        waitForExpectations(timeout: 5.0) { (error) in
            if let lError = error{
                XCTFail("Error: \(lError.localizedDescription)")
            }
        }

    }
    
    func testSightExpected(){
        let expect = expectation(description: "Expect")
        vm.outputs.sightsCoordinates.observeValues { (array:[Sight]) in
            if array.count != 0 {
            
                XCTAssert(true)
            }else {
                XCTFail("location is nil")
            }
            expect.fulfill()
        }
        vm.inputs.searchTextChanged("Kazan")
        vm.inputs.searchButtonPressed()
        waitForExpectations(timeout: 5.0) { (error) in
            if let lError = error{
                XCTFail("Error: \(lError.localizedDescription)")
            }
        }

    }
    
    
}
