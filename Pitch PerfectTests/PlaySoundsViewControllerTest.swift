//
//  PlaySoundsViewControllerTest.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 12/4/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import Foundation
import XCTest
import Pitch_Perfect

class PlaySoundsViewControllerTest : XCTestCase
{

    var controller:PlaySoundsViewController!

    override func setUp() {
        super.setUp()

        controller = PlaySoundsViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}