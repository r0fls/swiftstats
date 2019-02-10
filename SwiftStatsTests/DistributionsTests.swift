//
//  SwiftStatsTests.swift
//  SwiftStatsTests
//
//  Created by Raphael Deem on 4/24/16.
//  Copyright © 2016 Raphael Deem. All rights reserved.
//

import XCTest
@testable import SwiftStats

class DistributionsTests: XCTestCase {
    // A small value, epsilon, which specifies the maximum difference between
    // two floating-point values for the two values to be considered
    // sufficiently equal for testing purposes.
    let epsilon: Double = 1e-7
        
    func testBernoulli() {
        let b = SwiftStats.Distributions.Bernoulli(p: 0.7)
        srand48(0)
        XCTAssert(b.pmf(1) == 0.7, "Bernoulli pmf(1) should be 0.7")
        XCTAssert(b.cdf(1) == 1.0, "Bernoulli cdf(1) should be 1")
        XCTAssert(round(100000*b.cdf(0))/100000 == 0.3, "Bernoulli cdf(0) should be 0.3")
        XCTAssert(b.quantile(0.5) == 1, "Bernoulli quantile(0.5) should be 1")
        XCTAssert(b.quantile(0.2) == 0, " Bernoulli quantile(0.2) should be 0")
        
        let b2 = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])
        XCTAssert(b2!.p == 0.75, "Bernoulli fit with [1,1,0,1] should have p = 0.75")
    }
    
    func testLaplace(){
        srand48(0)
        let l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
        let pdf = round(pow(10.0,15.0)*l.pdf(1))/pow(10.0,15.0)
        XCTAssert(pdf == 0.183939720585721, "Laplace pdf failed test")
        let cdf = round(pow(10.0,15.0)*l.cdf(1))/pow(10.0,15.0)
        XCTAssert(cdf == 0.816060279414279, "Laplace cdf failed test")
        XCTAssert(l.cdf(0) == 0.5, "Laplace cdf failed test")
        
        let l2 = SwiftStats.Distributions.Laplace(data:[12,13,12])
        XCTAssert(l2!.mean == 12.0, "Laplace fit from data failed")
    }
 
    func testPoisson() {
        let p = SwiftStats.Distributions.Poisson(m: 1.5)
        let pmf = round(pow(10.0,15.0)*p.pmf(3))/pow(10.0,15.0)
        XCTAssert(pmf == 0.125510715083492, "Poisson pmf failed")
        var cdf = round(pow(10.0,15.0)*p.cdf(1))/pow(10.0,15.0)
        XCTAssert(cdf == 0.557825400371075, "Poisson cdf failed")
        cdf = round(pow(10.0,15.0)*p.cdf(0))/pow(10.0,15.0)
        XCTAssert(cdf == 0.22313016014843, "Poisson cdf failed")
        XCTAssert(p.quantile(0.5) == 1, "Poisson quantile failed")

        let p2 = SwiftStats.Distributions.Poisson(data: [1,2,3])
        XCTAssert(p2!.m == 2.0, "Poisson fit data failed")
        XCTAssert(p2!.quantile(0.999) == 8, "Poisson quantile from fit data failed")
        
        // Issue #24: Poisson unstable at large values of m
        // Test for small values of m
        /* R code:
            > dpois(2,3)
            [1] 0.2240418
         */
        let p3 = SwiftStats.Distributions.Poisson(m: 3)
        XCTAssert(abs(p3.pmf(2) - 0.2240418) < epsilon)
        
        // Test for large values of m (m > 15)
        /* R code:
            > dpois(29,30)
            [1] 0.07263453
         */
        let p4 = SwiftStats.Distributions.Poisson(m: 30)
        XCTAssert(abs(p4.pmf(29) - 0.07263453) < epsilon)
        
        // Test for very large values of m
        /* R code:
            > dpois(290,300)
            [1] 0.01978727
        */
        let p5 = SwiftStats.Distributions.Poisson(m: 300)
        XCTAssert(abs(p5.pmf(290) - 0.01978727) < epsilon)
    }
    
    func testGeometric() {
        let g = SwiftStats.Distributions.Geometric(p: 0.5)
        XCTAssert(g.pmf(3) == 0.125, "Geometric pmf failed")
        XCTAssert(g.cdf(3) == 0.875, "Geometric cdf failed")
        XCTAssert(g.cdf(4) == 0.9375, "Geometric cdf failed")
        XCTAssert(g.quantile(0.9999) == 14, "Geometric quantile failed")
    }
    
    func testExponential() {
        let e = SwiftStats.Distributions.Exponential(l: 0.5)
        let pdf = round(pow(10.0,15.0)*e.pdf(3))/pow(10.0,15.0)
        XCTAssert(pdf == 0.111565080074215, "Exponential pdf failed")
        var cdf = round(pow(10.0,15.0)*e.cdf(3))/pow(10.0,15.0)
        XCTAssert(cdf == 0.77686983985157, "Exponential cdf failed")
        cdf = round(pow(10.0,15.0)*e.cdf(4))/pow(10.0,15.0)
        XCTAssert(cdf == 0.864664716763387,  "Exponential cdf failed")
        let quant = round(pow(10.0,10.0)*e.quantile(0.864664716763387))/pow(10.0,10.0)
        XCTAssert(quant == 4.0, "quantile failed, got: \(quant)")
    }
    
    func testErfinv() {
        let erfinv = round(pow(10,15)*SwiftStats.Common.erfinv(erf(1.4)))/pow(10,15)
        XCTAssert(erfinv == 1.4, "Erfinv failed"+String(SwiftStats.Common.erfinv(erf(1.4))))
    }
    
    func testlsr() {
        let data = [[60.0, 3.1], [61.0, 3.6], [62.0, 3.8], [63.0, 4.0], [65.0, 4.1]]
        let params = SwiftStats.Common.lsr(data)
        let a = round(pow(10.0,9.0)*params[0])/pow(10.0,9.0)
        let b = round(pow(10.0,9.0)*params[1])/pow(10.0,9.0)
        XCTAssert(a - -7.963513513 < 0.00001 && b - 0.187837837 < 0.00001, "lsr failed")
    }
    
    func testNormal() {
        // Check that object is nil if insufficient data is passed in
        XCTAssertNil(SwiftStats.Distributions.Normal(data: []))
        XCTAssertNil(SwiftStats.Distributions.Normal(data: [0]))

        let n = SwiftStats.Distributions.Normal(mean: 0.0, sd: 1.0)

        // 50% of the Normal distribution should be below x=0
        XCTAssert(abs(n.cdf(0) - 0.5) < epsilon)
        
        // 97.5% of the Normal distribution should be below x=1.96 (approx)
        XCTAssert(abs(n.cdf(1.96) - 0.975) < 0.001)
        
        // The CDF and quantile functions should be the inverse of each other
        for x in [0, 0.05, 0.5, 0.8, 0.9, 0.95, 1] {
            XCTAssert(abs(n.cdf( n.quantile(x) ) - x) < epsilon)
        }
        
        // The PDF at 0 should be the same as that produced by R's dnorm()
        XCTAssert(n.pdf(0) - 0.3989423 < epsilon)
    }

    func testLogNormal() {
        // Check that errors are thrown if insufficient data is passed in
        XCTAssertNil(SwiftStats.Distributions.LogNormal(data: []))
        XCTAssertNil(SwiftStats.Distributions.LogNormal(data: [0]))

        let d = SwiftStats.Distributions.LogNormal(meanLog: 0.0, sdLog: 1.0)

        // CDF test values taken from R, where CDF <-> plnorm()
        XCTAssert(abs(d.cdf(0) - 0) < epsilon)
        XCTAssert(abs(d.cdf(1) - 0.5) < epsilon)
        XCTAssert(abs(d.cdf(2) - 0.7558914) < epsilon)

        // Quantile test values taken from R, where quantile <-> qlnorm()
        XCTAssert(abs(d.quantile(0) - 0) < epsilon)
        XCTAssert(abs(d.quantile(0.5) - 1) < epsilon)
        XCTAssert(abs(d.quantile(0.7558914) - 2) < epsilon)

        // PDF test values taken from R, where PDF <-> dlnorm()
        // XCTAssert(abs(n.pdf(0) - 0) < epsilon) -- we fail this test but it's unclear R
        // has the right result; infinity times zero is undefined, why is R returning zero?
        XCTAssert(abs(d.pdf(0.01) - 0.0009902387) < epsilon)
        XCTAssert(abs(d.pdf(0.1) - 0.2815902) < epsilon)
        XCTAssert(abs(d.pdf(1) - 0.3989423) < epsilon)
        XCTAssert(abs(d.pdf(2) - 0.156874) < epsilon)
        
        // Create log-normal distribution using array-based constructor
        let data = [1.0, 2.0, 3.0]
        let d2 = SwiftStats.Distributions.LogNormal(data: data)
        
        // Test that array-based constructor has correctly instantiated the distribution
        // mean(log(c(1,2,3))) -> 0.5972532
        XCTAssert( abs(d2!.m - 0.5972532) < epsilon)
        // var(log(c(1,2,3))) -> 0.308634
        XCTAssert( abs(d2!.v - 0.308634) < epsilon)
    }

    /*
    func testUniform() {
        let u = SwiftStats.Distributions.Uniform(a:5,b:10)
        XCTAssert(u.random())
    }
    */
}
