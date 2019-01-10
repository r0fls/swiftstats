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

    
    func testFactorial() {
        XCTAssert( SwiftStats.Common.factorial(4)! == 24)
        XCTAssert( SwiftStats.Common.factorial(0)! == 1)
        XCTAssertNil( SwiftStats.Common.factorial(-1))

        XCTAssert( abs(SwiftStats.Common.factorial(4.0)! - 24) < epsilon)
        XCTAssert( abs(SwiftStats.Common.factorial(0.0)! - 1) < epsilon)
        XCTAssert( abs(SwiftStats.Common.factorial(0.5)! - 0.8862269255) < epsilon)
        XCTAssertNil( SwiftStats.Common.factorial(-1.0))
    }
    
    
    func testChoose() {
        XCTAssert( SwiftStats.Common.choose(n: 2, k: 1) == 2)
        XCTAssert( SwiftStats.Common.choose(n: 10, k: 4) == 210)
        XCTAssert( SwiftStats.Common.choose(n: 5, k: 0) == 1)
        
        // Note that the following test results come from R.  Our code however
        // crashes when k < 0, however this isn't easily fixed as Binomial.pmf()
        // depends on this function not returning nil and not throwing.
        //XCTAssert( SwiftStats.Common.choose(n: 5, k: -1) == 0)
        //XCTAssert( SwiftStats.Common.choose(n: -5, k: -1) == 0)
        //XCTAssert( SwiftStats.Common.choose(n: -5, k: 1) == -5)

        XCTAssert( abs(SwiftStats.Common.choose(n: 2.0, k: 1) - 2) < epsilon)
        XCTAssert( abs(SwiftStats.Common.choose(n: 2.5, k: 2) - 1.875) < epsilon)
        
    }
    
    
    func testMean() {
        let data1 : [Int] = [1, 2, 3]
        XCTAssert(abs(SwiftStats.Common.mean(data1)! - 2.0) < epsilon)
        
        let data2 : [Double] = [1.0, 2.0, 3.0]
        XCTAssert(abs(SwiftStats.Common.mean(data2)! - 2.0) < epsilon)
    }
    
    
    func testSampleVariance() {
        let data1 : [Int] = [1, 2, 3, 4, 5]
        XCTAssert(abs(SwiftStats.Common.variance(data1)! - 2.5) < epsilon)

        let data2 : [Int] = [1]
        XCTAssertNil(SwiftStats.Common.variance(data2))

        let data3 : [Double] = [1, 2, 3, 4, 5]
        XCTAssert(abs(SwiftStats.Common.variance(data3)! - 2.5) < epsilon)
        
        let data4 : [Double] = [1]
        XCTAssertNil(SwiftStats.Common.variance(data4))
    }
    
    
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

        let data1i: [Int] = [0,1,2,3]
        let sd1i = SwiftStats.Common.sd(data1i)
        XCTAssert(abs(sd1i! - 1.290994449) < epsilon)

        /* R code:
         > d<-c(0)
         > sd(d)
         [1] NA
         */
        let data2: [Double] = [0]
        let sd2 = SwiftStats.Common.sd(data2)
        XCTAssert(sd2 == nil)
        
        let data2i: [Int] = [0]
        let sd2i = SwiftStats.Common.sd(data2i)
        XCTAssert(sd2i == nil)
        
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
        
        let data3i: [Int] = []
        let sd3i = SwiftStats.Common.sd(data3i)
        XCTAssert(sd3i == nil)
    }
    
    
    func testMedian() {
        let data1 : [Int] = [1,2,3]
        XCTAssert(abs(SwiftStats.Common.median(data1)! - 2.0) < epsilon)

        let data2 : [Int] = [1,2,3,4]
        XCTAssert(abs(SwiftStats.Common.median(data2)! - 2.5) < epsilon)

        let data3 : [Int] = [1]
        XCTAssert(abs(SwiftStats.Common.median(data3)! - 1.0) < epsilon)

        let data4 : [Int] = []
        XCTAssertNil(SwiftStats.Common.median(data4))

        let data5 : [Double] = [1,2,3]
        XCTAssert(abs(SwiftStats.Common.median(data5)! - 2.0) < epsilon)
        
        let data6 : [Double] = [1,2,3,4]
        XCTAssert(abs(SwiftStats.Common.median(data6)! - 2.5) < epsilon)
        
        let data7 : [Double] = [1]
        XCTAssert(abs(SwiftStats.Common.median(data7)! - 1.0) < epsilon)
        
        let data8 : [Double] = []
        XCTAssertNil(SwiftStats.Common.median(data8))
    }
}
