//
//  SwiftMapRequestTests.swift
//  SwiftMapRequestTests
//
//  Created by Ленар on 27.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import XCTest
import MapKit
@testable import SwiftMapRequest

class SwiftMapRequestTests: XCTestCase {
    
    var viewController:ViewController?
    var locationSearchTable:LocationSearchTable?
    var apiManager:APIManager?
    var city:City?
    var artwork:Artwork?
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyBoard.instantiateViewController(withIdentifier: "vc") as! ViewController)
        locationSearchTable = (storyBoard.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable)
        apiManager = APIManager()
        city = City()
        artwork = Artwork()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
        locationSearchTable = nil
        apiManager = nil
        city = nil
        artwork = nil
        super.tearDown()
    }
    
    func testCityCoordinateProperty(){
        city?.lat = 56.0000000
        city?.lng = 56.000000
        XCTAssert(city?.coordinate.latitude != nil && city?.coordinate.longitude != nil , "City haven't coordinate")
    }
    
    func testArtworkCoordinateProperty(){
        artwork?.lat = 56.0000000
        artwork?.lng = 56.000000
         XCTAssert(artwork?.coordinate.latitude != nil && artwork?.coordinate.longitude != nil , "Artwork haven't coordinate")
    }
    
    func testArtworkSubtitleProperty(){
        artwork?.locationName = "Сосква"
        XCTAssert(artwork?.subtitle != nil && artwork?.subtitle == artwork?.locationName , "Artwork haven't location subtitle")
    }
    
    func testArtworkFuncSetPinTintColor() {
        XCTAssert(artwork?.setPinTintColor() == MKPinAnnotationView.purplePinColor(), "Pin color not purple")
    }
    
    func testArtworkFuncCreateMapItem() {
        artwork?.lat = 56.000000
        artwork?.lng = 56.000000
        artwork?.title = "КазанCity"
        artwork?.locationName = "Русь-Матушка"
        XCTAssert(artwork?.createMapItem() != nil, "Func CreateMapItem() haven't return object(")
    }
    
    func testCityPropertyInLocationSearchTable(){
        XCTAssert(locationSearchTable?.city == locationSearchTable?.cities.last, "Is property not city")
    }
    
    func testParseAddressLocationSearchTable(){
        let expect = expectation(description: "ParseExpect")
        let searchBarText = "Kazan"
        var matchingItems:[MKMapItem] = []
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            matchingItems = response.mapItems
            if matchingItems.count != 0 {
                XCTAssert(self.locationSearchTable?.parseAddress(selectedItem: (matchingItems.first?.placemark)!) != "")
            } else {
                XCTFail("Can't parse address")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            if let lError = error{
                XCTFail("Error: \(lError.localizedDescription)")
            }
        }
        
    }
    
    func testNumberOfRowsInSectionLocationSearchTable() {
        XCTAssert((locationSearchTable?.tableView((locationSearchTable?.tableView)!, numberOfRowsInSection: 1))! > -1, "Cells count incorrect")
    }
    
    func testThatApiManagerInViewControllerCreated(){
        XCTAssertNotNil(viewController?.apiManager)
    }
    
    func testThatApiManagerDelegateIsSet(){
        viewController?.viewDidLoad()
        let vc = viewController?.apiManager.delegate as! ViewController
        XCTAssertTrue(viewController == vc)
    }
    
    
    func testThatLocationManagerInViewControllerCreated(){
        XCTAssertNotNil(viewController?.locationManager)
    }
    
    func testThatLocationManagerDelegateIsSet() {
        viewController?.viewDidLoad()
        let vc = viewController?.locationManager.delegate as! ViewController
        XCTAssertTrue(viewController == vc)
    }
    
}
