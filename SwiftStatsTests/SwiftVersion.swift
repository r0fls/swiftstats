//
//  SwiftVersion.swift
//  SwiftStatsTests
//
//  Created by Matthew Walker on 11/01/19.
//  Copyright © 2019 Raphael Deem. All rights reserved.
//

import XCTest

class SwiftVersion: XCTestCase {
    func testVersion() {
        #if swift(>=4.2)
        XCTAssert(true, "Expected Swift version 4.2 or greater")
        #else
        XCTFail()
        #endif
    }
}
