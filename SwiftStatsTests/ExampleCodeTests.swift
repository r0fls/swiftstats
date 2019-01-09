//
//  ExampleCodeTests.swift
//  
//
//  Created by Matthew Walker on 2/12/18.
//

@testable import SwiftStats
import XCTest

class ExampleCodeTests: XCTestCase {
    // A small value, epsilon, which specifies the maximum difference between
    // two floating-points for the two values to be considered sufficiently
    // equal.
    let epsilon: Double = 1e-7

    func testExampleCode() throws {
        // NOTE!  If code in this test needs to be changed in order for the
        // test to pass, ensure that the updated code is copied-and-pasted
        // back into README.md.
        
        // *********
        // Example 1:
        let n1 = SwiftStats.Distributions.Normal(m:0, v:1.0)
        print(n1.random())
        
        // *********
        // Example 2:
        let n2 = try SwiftStats.Distributions.Normal(data:[0,-1,1,0])
        print(n2.random())
        
        // *********
        // Example 3:
        let median1 = SwiftStats.Common.median([1,4,3,2]) // -> 2.5
        XCTAssert(abs(median1 - 2.5) < epsilon)
        let median2 = SwiftStats.Common.median([3,1,2]) // -> 2
        XCTAssert(abs(median2 - 2.0) < epsilon)
        
        // *********
        // Example 4:
        let n3 = SwiftStats.Distributions.Normal(m:0, v:1.0)
        
        // default randomly seeded variable
        print(n3.random())
        
        // using the distributions' seed method
        n3.seed(42)
        let random1 = n3.random()
        XCTAssert(abs(random1 - 0.6573591680550961) < epsilon)
        
        // using srand48() directly
        srand48(1)
        let random2 = n3.random()
        XCTAssert(abs(random2 - -1.7320723047642332) < epsilon)
    }
}
