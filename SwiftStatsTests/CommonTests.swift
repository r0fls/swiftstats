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
    // A small value, epsilon, which specifies the maximum difference between
    // two floating-point values for the two values to be considered
    // sufficiently equal for testing purposes.
    let epsilon: Double = 1e-7

    
    // TODO: We should have test cases here for the Common functions
    
    
    func testStandardDeviation() {
        /* R code:
         > options(digits=10)
         > d <- c(0,1,2,3)
         > sd(d)
         [1] 1.290994449
         */
        let data1: [Double] = [0,1,2,3]
        let sd1 = SwiftStats.Common.sd(data1)
        XCTAssert(abs(sd1! - 1.290994449) < epsilon)
        
        /* R code:
         > d<-c(0)
         > sd(d)
         [1] NA
         */
        let data2: [Double] = [0]
        let sd2 = SwiftStats.Common.sd(data2)
        XCTAssert(sd2 == nil)
        
        /* R code:
         > d<-c()
         > d
         NULL
         > sd(d)
         [1] NA
         */
        let data3: [Double] = []
        let sd3 = SwiftStats.Common.sd(data3)
        XCTAssert(sd3 == nil)
    }
}
