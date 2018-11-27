//
//  SwiftStatsTests.swift
//  SwiftStatsTests
//
//  Created by Raphael Deem on 4/24/16.
//  Copyright © 2016 Raphael Deem. All rights reserved.
//

import XCTest
@testable import SwiftStats

class SwiftStatsTests: XCTestCase {
    // A small value, epsilon, which specifies the maximum difference between two floating-point
    // for the two values to be considered sufficiently equal.
    let epsilon: Double = 1e-7
    
    func testVersion() {
        #if swift(>=4.2)
          XCTAssert(true, "Expected Swift version 4.2 or greater")
        #else
          XCTFail()
        #endif
    }
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBernoulli() {
        var b = SwiftStats.Distributions.Bernoulli(p: 0.7)
        srand48(0)
        XCTAssert(b.Pmf(1) == 0.7, "Bernoulli pmf(1) should be 0.7")
        XCTAssert(b.Cdf(1) == 1.0, "Bernoulli Cdf(1) should be 1")
        XCTAssert(round(100000*b.Cdf(0))/100000 == 0.3, "Bernoulli Cdf(0) should be 0.3")
        XCTAssert(b.Quantile(0.5) == 1, "Bernoulli Quantile(0.5) should be 1")
        XCTAssert(b.Quantile(0.2) == 0, " Bernoulli Quantile(0.2) should be 0")
        XCTAssert(b.Random() == 0, "Bernoulli random() should equal 1 with test seed")
        b = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])
        XCTAssert(b.p == 0.75, "Bernoulli fit with [1,1,0,1] should have p = 0.75")
    }
    
    func testLaplace(){
        srand48(0)
        var l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
        let pdf = round(pow(10.0,15.0)*l.Pdf(1))/pow(10.0,15.0)
        XCTAssert(pdf == 0.183939720585721, "Laplace pdf failed test")
        let n = round(pow(10.0,14.0)*l.Random())/pow(10.0,14.0)
        XCTAssert(n == -1.07395068471681, "Laplace Random failed test")
        let cdf = round(pow(10.0,15.0)*l.Cdf(1))/pow(10.0,15.0)
        XCTAssert(cdf == 0.816060279414279, "Laplace cdf failed test")
        XCTAssert(l.Cdf(0) == 0.5, "Laplace cdf failed test")
        
        l = SwiftStats.Distributions.Laplace(data:[12,13,12])
        XCTAssert(l.mean == 12.0, "Laplace fit from data failed")
    }
 
    func testPoisson() {
        var p = SwiftStats.Distributions.Poisson(m: 1.5)
        let pmf = round(pow(10.0,15.0)*p.Pmf(3))/pow(10.0,15.0)
        XCTAssert(pmf == 0.125510715083492, "Poisson Pmf failed")
        var cdf = round(pow(10.0,15.0)*p.Cdf(1))/pow(10.0,15.0)
        XCTAssert(cdf == 0.557825400371075, "Poisson Cdf failed")
        cdf = round(pow(10.0,15.0)*p.Cdf(0))/pow(10.0,15.0)
        XCTAssert(cdf == 0.22313016014843, "Poisson Cdf failed")
        XCTAssert(p.Quantile(0.5) == 1, "Poisson Quantile failed")
        srand48(0)
        XCTAssert(p.Random() == 0, "Poisson random failed")
        
        p = SwiftStats.Distributions.Poisson(data: [1,2,3])
        XCTAssert(p.m == 2.0, "Poisson fit data failed")
        XCTAssert(p.Quantile(0.999) == 8, "Poisson Quantile from fit data failed")
    }
    
    func testGeometric() {
        let g = SwiftStats.Distributions.Geometric(p: 0.5)
        XCTAssert(g.Pmf(3) == 0.125, "Geometric Pmf failed")
        XCTAssert(g.Cdf(3) == 0.875, "Geometric Cdf failed")
        XCTAssert(g.Cdf(4) == 0.9375, "Geometric Cdf failed")
        XCTAssert(g.Quantile(0.9999) == 14, "Geometric quantile failed")
        srand48(0)
        XCTAssert(g.Random() == 1)
    }
    
    func testExponential() {
        let e = SwiftStats.Distributions.Exponential(l: 0.5)
        let pdf = round(pow(10.0,15.0)*e.Pdf(3))/pow(10.0,15.0)
        XCTAssert(pdf == 0.111565080074215, "Exponential Pdf failed")
        var cdf = round(pow(10.0,15.0)*e.Cdf(3))/pow(10.0,15.0)
        XCTAssert(cdf == 0.77686983985157, "Exponential Cdf failed")
        cdf = round(pow(10.0,15.0)*e.Cdf(4))/pow(10.0,15.0)
        XCTAssert(cdf == 0.864664716763387,  "Exponential Cdf failed")
        let quant = round(pow(10.0,10.0)*e.Quantile(0.864664716763387))/pow(10.0,10.0)
        XCTAssert(quant == 4.0, "Quantile failed, got: \(quant)")
        srand48(0)
        let rand = round(pow(10.0,15.0)*e.Random())/pow(10.0,15.0)
        XCTAssert(rand == 0.374655420044752, "Exponential Random() failed, got: "+String(rand))
    }
    
    func testErfinv() {
        let erfinv = round(pow(10,15)*SwiftStats.Common.erfinv(erf(1.4)))/pow(10,15)
        XCTAssert(erfinv == 1.4, "Erfinv failed"+String(SwiftStats.Common.erfinv(erf(1.4))))
    }
    
    func testlsr() {
        let data = [[60.0, 3.1], [61.0,	3.6], [62.0, 3.8], [63.0,	4.0], [65.0,	4.1]]
        let params = SwiftStats.Common.lsr(data)
        let a = round(pow(10.0,9.0)*params[0])/pow(10.0,9.0)
        let b = round(pow(10.0,9.0)*params[1])/pow(10.0,9.0)
        XCTAssert(a - -7.963513513 < 0.00001 && b - 0.187837837 < 0.00001, "lsr failed")
    }
    
    func testNormal() {
        let n = SwiftStats.Distributions.Normal(mean: 0.0, sd: 1.0)

        // 50% of the Normal distribution should be below x=0
        XCTAssert(abs(n.Cdf(0) - 0.5) < epsilon)
        
        // 97.5% of the Normal distribution should be below x=1.96 (approx)
        XCTAssert(abs(n.Cdf(1.96) - 0.975) < 0.001)
        
        // The CDF and Quantile functions should be the inverse of each other
        for x in [0, 0.05, 0.5, 0.8, 0.9, 0.95, 1] {
            XCTAssert(abs(n.Cdf( n.Quantile(x) ) - x) < epsilon)
        }
        
        // The PDF at 0 should be the same as that produced by R's dnorm()
        XCTAssert(n.Pdf(0) - 0.3989423 < epsilon)
    }
    /*
    func testUniform() {
        let u = SwiftStats.Distributions.Uniform(a:5,b:10)
        XCTAssert(u.Random())
    }
    */
}
