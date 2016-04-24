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
    
    func testExample() {
        var b = SwiftStats.Distributions.Bernoulli(p: 0.7)
        print(b.Pmf(1)) // 0.7
        print(b.Cdf(1)) // 1.0
        print(b.Cdf(0)) // 0.3
        print(b.Quantile(0.5)) // 1
        print(b.Quantile(0.2)) // 1
        print(b.random()) // 1
        b = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])
        print(b.p)
        print(b.random())
        
        
        var l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
        print(l.pdf(1))
        print(l.random())
        print(l.Cdf(1))
        print(l.Cdf(0))
        
        l = SwiftStats.Distributions.Laplace(data:[12,13,12])
        print(l.mean)
        
        var p = SwiftStats.Distributions.Poisson(m: 1.5)
        print(p.Pmf(3))
        print(p.Cdf(1))
        print(p.Cdf(0))
        print(p.Quantile(0.5))
        print(p.random())
        
        p = SwiftStats.Distributions.Poisson(data: [1,2,3])
        print(p.m)
        print(p.Quantile(0.9))
        
        let g = SwiftStats.Distributions.Geometric(p: 0.5)
        print(g.Pmf(3))
        print(g.Cdf(3))
        print(g.Cdf(4))
        print(g.Quantile(0.9999))
        print(g.random())
        
        let e = SwiftStats.Distributions.Exponential(l: 0.5)
        print(e.pdf(3))
        print(e.Cdf(3))
        print(e.Cdf(4))
        print(e.Quantile(0.9999))
        print(e.random())

        print(SwiftStats.Common.erfinv(erf(1.4)))
        
        
        var n = SwiftStats.Distributions.Normal(m: 0.0, v: 3)
        print(n.Cdf(pow(3,0.5))-n.Cdf(-pow(3,0.5)))
        print(n.Quantile(n.Cdf(3)))
        n = SwiftStats.Distributions.Normal(data: [1,2,1,0,1,2])
        print(n.v)
        
        let u = SwiftStats.Distributions.Uniform(a:5,b:10)
        print(u.random())

    
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
