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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBernoulli() {
        srand48(0)
        var b = SwiftStats.Distributions.Bernoulli(p: 0.7)
        XCTAssert(b.Pmf(1) == 0.7, "Bernoulli pmf(1) should be 0.7")
        XCTAssert(b.Cdf(1) == 1.0, "Bernoulli Cdf(1) should be 1")
        XCTAssert(round(100000*b.Cdf(0))/100000 == 0.3, "Bernoulli Cdf(0) should be 0.3")
        XCTAssert(b.Quantile(0.5) == 1, "Bernoulli Quantile(0.5) should be 1")
        XCTAssert(b.Quantile(0.2) == 0, " Bernoulli Quantile(0.2) should be 0")
        XCTAssert(b.random() == 0, "Bernoulli random() should equal 1 with test seed")
        b = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])
        XCTAssert(b.p == 0.75, "Bernoulli fit with [1,1,0,1] should have p = 0.75")
    }
    func testLaplace(){
        srand48(0)
        var l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
        let pdf = round(pow(10.0,15.0)*l.Pdf(1))/pow(10.0,15.0)
        XCTAssert(pdf == 0.183939720585721, "Laplace pdf failed test")
        let n = round(pow(10.0,14.0)*l.random())/pow(10.0,14.0)
        XCTAssert(n == -1.07395068471681, "Laplace random failed test")
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
        XCTAssert(p.random() == 0, "Poisson random failed")
        
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
        XCTAssert(g.random() == 1)
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
        let rand = round(pow(10.0,15.0)*e.random())/pow(10.0,15.0)
        XCTAssert(rand == 0.374655420044752, "Exponential Random() failed, got: "+String(rand))
    }
    
    func testErfinv() {
        let erfinv = round(pow(10,15)*SwiftStats.Common.erfinv(erf(1.4)))/pow(10,15)
        XCTAssert(erfinv == 1.4, "Erfinv failed"+String(SwiftStats.Common.erfinv(erf(1.4))))
    }
    /*
    func testNormal() {
        var n = SwiftStats.Distributions.Normal(m: 0.0, v: 3)
        XCTAssert(n.Cdf(pow(3,0.5))-n.Cdf(-pow(3,0.5)))
        XCTAssert(n.Quantile(n.Cdf(3)))
        n = SwiftStats.Distributions.Normal(data: [1,2,1,0,1,2])
        XCTAssert(n.v)
    }
    func testUniform() {
        let u = SwiftStats.Distributions.Uniform(a:5,b:10)
        XCTAssert(u.random())
    }
    */
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
