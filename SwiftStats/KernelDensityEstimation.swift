//
//  KernelDensityEstimation.swift
//  SwiftStats
//
//  Created by Matthew Walker on 9/01/19.
//  Copyright © 2019 Raphael Deem. All rights reserved.
//

import Foundation

extension Common {
    public class KernelDensityEstimation {
        enum Errors : Error {
            case AtLeastTwoDataPointsRequired
        }
        
        let data : [Double]
        let bandwidth : Double
        let n: Double
        
        init(_ data: [Double], bandwidth: Double?) throws {
            self.data = data
            self.n = Double(data.count)
            
            if bandwidth != nil {
                self.bandwidth = bandwidth!
            } else {
                let sd = SwiftStats.Common.sd(data)
                if sd == nil {
                    throw Errors.AtLeastTwoDataPointsRequired
                }
                self.bandwidth = 1.06 * sd! * pow(n, -1.0/5.0)
            }
        }
        
        func evaluate(_ x: Double) -> Double {
            // Go through each data point, calculate its contribution at the
            // given x.
            var result : Double = 0
            for d in data {
                result += gaussianKernel(x, mean: d, sd: bandwidth) / n
            }
            
            return result
        }
        
        func gaussianKernel(_ x: Double, mean: Double, sd: Double) -> Double {
            let distribution = SwiftStats.Distributions.Normal(mean: mean, sd: sd)
            return distribution.pdf(x)
        }
    }
}
