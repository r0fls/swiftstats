//
//  KDETests.swift
//  SwiftStatsTests
//
//  Created by Matthew Walker on 9/01/19.
//  Copyright © 2019 Raphael Deem. All rights reserved.
//

import XCTest
@testable import SwiftStats


class KDETests: XCTestCase {
    // A small value, epsilon, which specifies the maximum difference between
    // two floating-point values for the two values to be considered
    // sufficiently equal for testing purposes.  Note that this value is larger
    // than typically used because R's density function does not allow
    // evaluation at a specified value and instead the value is interpolated.
    let epsilon: Double = 1e-3

    
    func testSingleDataPoint() {
        // Given data of [0], and a bandwidth of 1, R's density function
        // approximates dnorm(x, mean=0, sd=1)
        
        let data : [Double] = [0]
        
        let kde = SwiftStats.KernelDensityEstimation(data, bandwidth: 1)
        
        let density = kde!.evaluate(0)
        
        XCTAssert(abs(density - 0.3989423) < epsilon)
    }

    
    func testTwoIdenticalDataPoints() {
        // Given data of [0, 0], and a bandwidth of 1, R's density function
        // approximates dnorm(x, mean=0, sd=1).  Note that the result is
        // the same as for a single value, thus the result has been normalised.

        let data : [Double] = [0, 0]
        
        let kde = SwiftStats.KernelDensityEstimation(data, bandwidth: 1)
        
        let density = kde!.evaluate(0)
        
        XCTAssert(abs(density - 0.3989423) < epsilon)
    }

    
    func testTwoDistantDataPoints() {
        // Given data of [0, 10], and a bandwidth of 1, R's density function
        // gives half the value of the one-point test.  This is reasonable as
        // the result is normalised and the second point is so far away as to
        // not contribute to the result.
        /* R code:
        > fit <- density(c(0, 10), bw=1)
        > approx(fit$x, fit$y, 0)
        $x
        [1] 0
        
        $y
        [1] 0.1994125
        */

        let data : [Double] = [0, 10]
        
        let kde = SwiftStats.KernelDensityEstimation(data, bandwidth: 1)
        
        let density = kde!.evaluate(0)
        XCTAssert(abs(density - 0.1994125) < epsilon)
    }

    func testTwoInteractingDataPoints() {
        // Given data of [0, 1], and a bandwidth of 1, R's density function
        // gives:
        /* R code:
         > fit <- density(c(0, 1), bw=1)
         > approx(fit$x, fit$y, 0)
         $x
         [1] 0
         
         $y
         [1] 0.320532
        */
        
        let data : [Double] = [0, 1]
        
        let kde = SwiftStats.KernelDensityEstimation(data, bandwidth: 1)
        
        let density = kde!.evaluate(0)
        XCTAssert(abs(density - 0.320532) < epsilon)
    }
    
    func testNumerousDataPoints() {
        // Given the example from the Kernel Density Estimation Wikipedia page:
        /* R code:
         > fit <- density(c(-2.1, -1.3, -0.4, 1.9, 5.1, 6.2), bw=sqrt(2.25))
         > approx(fit$x, fit$y, 0)
         $x
         [1] 0
         
         $y
         [1] 0.1099665
         
         > approx(fit$x, fit$y, 7)
         $x
         [1] 7
         
         $y
         [1] 0.05850251
         */
        
        let data : [Double] = [-2.1, -1.3, -0.4, 1.9, 5.1, 6.2]
        
        let kde = SwiftStats.KernelDensityEstimation(data,
                                                     bandwidth: sqrt(2.25))
        
        let density0 = kde!.evaluate(0)
        XCTAssert(abs(density0 - 0.1099665) < epsilon)
        
        let density7 = kde!.evaluate(7)
        XCTAssert(abs(density7 - 0.05850251) < epsilon)
    }
    
    func testAutomaticBandwithEstimatorThrows() throws {
        // Check that the constructor returns nil if insufficient data is passed
        // in while asking for automatic bandwidth selection
        XCTAssertNil(SwiftStats.KernelDensityEstimation([],
                                                        bandwidth:nil))
        XCTAssertNil(SwiftStats.KernelDensityEstimation([1.0],
                                                        bandwidth:nil))
    }
    
    func testTwoDataPointsWithSilvermansBandwidthEstimator() {
        // Given data of [0,1] and the bandwidth estimator as described on the
        // Wikipedia article
        /* R code:
         > d <- c(0, 1)
         > n <- length(d)
         > bw <- 1.06 * sd(d) * n**(-1/5)
         > bw
         [1] 0.6525065391
         > fit <- density(d, bw=bw)
         > approx(fit$x, fit$y, 0)
         $x
         [1] 0
         
         $y
         [1] 0.4003494754
         */
        
        let data : [Double] = [0, 1]
        
        let kde = SwiftStats.KernelDensityEstimation(data,
                                                     bandwidth:nil)
        XCTAssert(abs(kde!.bandwidth - 0.6525065391) < epsilon)

        let density = kde!.evaluate(0)
        XCTAssert(abs(density - 0.4003494754) < epsilon)
    }

}
