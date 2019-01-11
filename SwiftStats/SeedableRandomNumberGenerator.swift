//
//  SeedableRandomNumberGenerator.swift
//  SwiftStats
//
//  Created by Matthew Walker on 11/01/19.
//  Copyright © 2019 Raphael Deem. All rights reserved.
//

import Foundation

/**
 A basic implementation of a random number generator that can be given a seed.
 It depends on srand48() and drand48(), so any calls to those two functions
 outside of this class will impact the reproducibility of the generator.
 */
public class SeedableRandomNumberGenerator : RandomNumberGenerator {
    /**
     Creates a new instance and seeds the generator using a call to
     `srand48(seed)`.
     */
    public init(seed: Int = 0) {
        srand48(seed)
    }
    
    /**
     Generates the next random number; uses drand48().
     */
    public func next() -> UInt64 {
        return UInt64(drand48() * Double(UInt64.max))
    }
}
