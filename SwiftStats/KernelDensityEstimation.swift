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
        let data : [Double]
        let bandwidth : Double
        let n: Double
        
        init(_ data: [Double], bandwidth: Double?) {
            self.data = data
            if bandwidth != nil {
                self.bandwidth = bandwidth!
            } else {
                self.bandwidth = 1.0 // FIXME
            }
            
            self.n = Double(data.count)
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
