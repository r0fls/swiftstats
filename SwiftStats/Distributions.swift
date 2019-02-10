import Foundation

/**
 Protocol for discrete distributions.
 
 Defines the `quantile()` method that must be implemented.
 */
public protocol DiscreteDistribution {
    func quantile(_ p: Double) -> Int
}

extension DiscreteDistribution {
    /**
     Single discrete random value using a user-provided random number generator
     
     - Parameters:
       - using: A random number generator
     
     - Returns:
     A random number from the distribution represented by the instance
     */
    public func random<T: RandomNumberGenerator>(using generator: inout T) -> Int {
        let x = Double.random(in: 0.0...1.0,
                              using: &generator)
        return quantile(x)
    }
    
    /**
     Single discrete random value using the system random number generator
     
     - Returns:
     A random number from the distribution represented by the instance
     */
    public func random() -> Int {
        var rng = SystemRandomNumberGenerator()
        return random(using: &rng)
    }
    
    /**
     Array of discrete random values
     - Parameter n: number of values to produce
     - Complexity: O(n)
     */
    public func random(_ n: Int) -> [Int] {
        var results: [Int] = []
        for _ in 0..<n {
            results.append(random())
        }
        return results
    }

}

/**
 Protocol for continuous distributions.
 
 Defines the `quantile()` method that must be implemented.
 */
public protocol ContinuousDistribution {
    func quantile(_ p: Double) -> Double
}

extension ContinuousDistribution {
    /**
     Single discrete random value using a user-provided random number generator
     
     - Parameters:
       - using: A random number generator
     
     - Returns:
     A random number from the distribution represented by the instance
     */
    public func random<T: RandomNumberGenerator>(using generator: inout T) -> Double {
        let x = Double.random(in: 0.0...1.0,
                              using: &generator)
        return quantile(x)
    }
    
    
    /**
     Single discrete random value using the system random number generator
     
     - Returns:
     A random number from the distribution represented by the instance
     */
    public func random() -> Double {
        var rng = SystemRandomNumberGenerator()
        return random(using: &rng)
    }
    
    
    /**
     Array of discrete random values
     - Parameter n: number of values to produce
     - Complexity: O(n)
     */
    public func random(_ n: Int) -> [Double] {
        var results: [Double] = []
        for _ in 0..<n {
            results.append(random())
        }
        return results
    }

}


public struct Distributions {
    private static let pi = Double.pi
    

    public class Bernoulli: DiscreteDistribution {
        var p: Double
        
        public init(p: Double) {
            self.p = p
        }
        
        public convenience init?<T: BinaryInteger>(data: [T]) {
            guard let m = Common.mean(data) else {
                return nil
            }
            self.init(p: m)
        }
        
        public func pmf(_ k: Int) -> Double {
            if k == 1 {
                return self.p
            }
            if k == 0 {
                return 1 - self.p
            }
            return -1
        }
        
        public func cdf(_ k: Int) -> Double {
            if k < 0 {
                return 0
            }

            if k < 1 {
                return 1 - self.p
            }
            if k >= 1 {
                return 1
            }
            return -1
        }
        
        public func quantile(_ p: Double) -> Int {
            if p < 0 {
                return -1
            }
            else if p < 1 - self.p {
                return 0
            }
            else if p <= 1 {
                return 1
            }
            return -1
        }
    }

    public class Laplace: ContinuousDistribution {
        var mean: Double
        var b: Double

        public init (mean: Double, b: Double) {
            self.mean = mean
            self.b = b
        }

        public convenience init?(data: [Double]) {
            guard let m = Common.median(data) else {
                return nil
            }
            var b = 0.0
            for i in 0..<data.count {
                b += abs(data[i] - m)
            }
            b = b/Double(data.count)
            self.init(mean: m, b: b)
        }

        public func pdf(_ x: Double) -> Double {
            return exp(-abs(x - self.mean)/self.b)/2
        }

        public func cdf(_ x: Double) -> Double {
            if x < self.mean {
                return exp((x - self.mean)/self.b)/2
            }
            else if x >= self.mean {
                return 1 - exp((self.mean - x)/self.b)/2
            }
            else {
                return -1
            }
        }

        public func quantile(_ p: Double) -> Double {
            if p > 0 && p <= 0.5 {
                return self.mean + self.b*log(2*p)
            }
            if p > 0.5 && p < 1 {
                return self.mean - self.b*log(2*(1-p))
            }
            return -1
        }
    }

    public class Poisson: DiscreteDistribution {
        var m: Double
        public init(m: Double) {
            self.m = m
        }

        public convenience init?(data: [Double]) {
            guard let m = Common.mean(data) else {
                return nil
            }
            self.init(m: m)
        }

        public func pmf(_ k: Int) -> Double {
            return exp(Double(k) * log(m) - m - lgamma(Double(k+1)))
        }

        public func cdf(_ k: Int) -> Double {
            var total = Double(0)
            for i in 0..<k+1 {
                total += self.pmf(i)
            }
            return total
        }

        public func quantile(_ x: Double) -> Int {
            var total = Double(0)
            var j = 0
            total += self.pmf(j)
            while total < x {
                j += 1
                total += self.pmf(j)
            }
            return j
        }
    }

    public class Geometric: DiscreteDistribution {
        var p: Double
        public init(p: Double) {
            self.p = p
        }

        public convenience init?(data: [Double]) {
            guard let m = Common.mean(data) else {
                return nil
            }
            self.init(p: 1/m)
        }

        public func pmf(_ k: Int) -> Double {
            return pow(1 - self.p, Double(k - 1))*self.p
        }

        public func cdf(_ k: Int) -> Double {
            return 1 - pow(1 - self.p, Double(k))
        }

        public func quantile(_ p: Double) -> Int {
            return Int(ceil(log(1 - p)/log(1 - self.p)))
        }
    }

    public class Exponential: ContinuousDistribution {
        var l: Double
        public init(l: Double) {
            self.l = l
        }

        public convenience init?(data: [Double]) {
            guard let m = Common.mean(data) else {
                return nil
            }
            self.init(l: 1/m)
        }

        public func pdf(_ x: Double) -> Double {
            return self.l*exp(-self.l*x)
        }

        public func cdf(_ x: Double) -> Double {
            return 1 - exp(-self.l*x)
        }

        public func quantile(_ p: Double) -> Double {
            return -log(1 - p)/self.l
        }
    }

    public class Binomial: DiscreteDistribution {
        var n: Int
        var p: Double
        public init(n: Int, p: Double) {
            self.n = n
            self.p = p
        }

        public func pmf(_ k: Int) -> Double {
            let r = Double(k)
            return Double(Common.choose(n: self.n, k: k))*pow(self.p, r)*pow(1 - self.p, Double(self.n - k))
        }
        
        public func cdf(_ k: Int) -> Double {
            var total = Double(0)
            for i in 1..<k + 1 {
                total += self.pmf(i)
            }
            return total
        }
        
        public func quantile(_ x: Double) -> Int {
            var total = Double(0)
            var j = 0
            while total < x {
                j += 1
                total += self.pmf(j)
            }
            return j
        }
    }

    public class Normal: ContinuousDistribution {
        // mean and variance
        var m: Double
        var v: Double

        public init(m: Double, v: Double) {
            self.m = m
            self.v = v
        }
        
        public convenience init(mean: Double, sd: Double) {
            // This contructor takes the mean and standard deviation, which is the more
            // common parameterisation of a normal distribution.
            let variance = pow(sd, 2)
            self.init(m: mean, v: variance)
        }

        public convenience init?(data: [Double]) {
            // this calculates the mean twice, since variance()
            // uses the mean and calls mean()
            guard let v = Common.variance(data) else {
                return nil
            }
            guard let m = Common.mean(data) else {
                return nil // This shouldn't ever occur
            }
            self.init(m: m, v: v)
        }

        public func pdf(_ x: Double) -> Double {
            return (1/pow(self.v*2*pi,0.5))*exp(-pow(x-self.m,2)/(2*self.v))
        }

        public func cdf(_ x: Double) -> Double {
            return (1 + erf((x-self.m)/pow(2*self.v,0.5)))/2
        }

        public func quantile(_ p: Double) -> Double {
            return self.m + pow(self.v*2,0.5)*Common.erfinv(2*p - 1)
        }
    }
    
    /**
     The log-normal continuous distribution.
     
     Three constructors are provided.
     
     There are two parameter-based constructors; both take the mean of the
     distribution on the log scale.  One constructor takes the variance of
     the distribution on the log scale, and the other takes the standard
     deviation on the log scale.  See `LogNormal.init(meanLog:varianceLog:)` and
     `LogNormal.init(meanLog:sdLog:)`.
     
     One data-based constructor is provided.  Given an array of sample values,
     a log-normal distribution will be created parameterised by the mean and
     variance of the sample data.
    */
    public class LogNormal: ContinuousDistribution {
        // Mean and variance
        var m: Double
        var v: Double
        
        /**
         Constructor that takes the mean and the variance of the distribution
         under the log scale.
         */
        public init(meanLog: Double, varianceLog: Double) {
            self.m = meanLog
            self.v = varianceLog
        }
        
        /**
         Constructor that takes the mean and the standard deviation of the
         distribution under the log scale.
         */
        public convenience init(meanLog: Double, sdLog: Double) {
            // This contructor takes the mean and standard deviation, which is
            // the more common parameterisation of a log-normal distribution.
            let varianceLog = pow(sdLog, 2)
            self.init(meanLog: meanLog, varianceLog: varianceLog)
        }
        
        /**
         Constructor that takes sample data and uses the the mean and the
         standard deviation of the sample data under the log scale.
         */
        public convenience init?(data: [Double]) {
            // This calculates the mean twice, since variance()
            // uses the mean and calls mean()

            // Create an array of Doubles the same length as data
            var logData = [Double](repeating: 0, count: data.count)
            
            // Find the log of all the values in the array data
            for i in stride(from: 0, to: data.count, by: 1) {
                logData[i] = log(data[i])
            }
            
            guard let v = Common.variance(logData) else {
                return nil
            }
            
            guard let m = Common.mean(logData) else {
                return nil // This shouldn't ever occur
            }
        
            self.init(meanLog: m,
                      varianceLog: v)
        }
        
        public func pdf(_ x: Double) -> Double {
            return 1/(x*sqrt(2*pi*v)) * exp(-pow(log(x)-m,2)/(2*v))
        }
        
        public func cdf(_ x: Double) -> Double {
            return 0.5 + 0.5*erf((log(x)-m)/sqrt(2*v))
        }
        
        public func quantile(_ p: Double) -> Double {
            return exp(m + sqrt(2*v)*Common.erfinv(2*p - 1))
        }

    }

    public class Uniform: ContinuousDistribution {
        // a and b are endpoints, that is
        // values will be distributed uniformly between points a and b
        var a: Double
        var b: Double

        public init(a: Double, b: Double) {
            self.a = a
            self.b = b
        }

        public func pdf(_ x: Double) -> Double {
            if x>a && x<b {
                return 1/(b-a)
            }
            return 0
        }

        public func cdf(_ x: Double) -> Double {
            if x<a {
                return 0
            }
            else if x<b {
                return (x-a)/(b-a)
            }
            else if x>=b {
                return 1
            }
            return 0
        }

        public func quantile(_ p: Double) -> Double {
            if p>=0 && p<=1{
                return p*(b-a)+a
            }
            return Double.nan
        }
    }
}
