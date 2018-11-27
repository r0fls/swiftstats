//
//  CommonTests.swift
//  SwiftStatsTests
//
//  Created by Matthew Walker on 27/11/18.
//  Copyright © 2018 Raphael Deem. All rights reserved.
//

import XCTest
@testable import SwiftStats


class CommonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogArray() {
        let data = [1.0, 2.0, 3.0]
        let dataLog = Common.logArray(data)
        
        for i in stride(from: 0, to: data.count, by: 1) {
            XCTAssert( dataLog[i] == log(data[i]) )
        }
    }

}
