import Foundation

/**
 Common Statistical Functions
 
 This `struct` is used as a namespace to separate the stats functions in
 SwiftStats.
 
 In general, the functions here do not throw exceptions but `nil` values can be
 returned.  For example, to calculate the standard deviation of a sample
 requires at least two data points.  If the array that is passed to `sd()` does
 not have at least two values then `nil` is returned.
 
 Functions here are often generic in that they work for a range of types (for
 example, the same function is called to calculate the mean of Int8, Int32,
 Int64, or Int arrays).  Separate implementations can be found for BinaryInteger
 and BinaryFloatingPoint protocols.
 */
public struct Common {
    private static let pi = Double.pi
    
    /**
     Calculate `n!` for values of `n` that conform to the BinaryInteger
     protocol.  Returns `nil` if `n` is less than zero.
     */
    public static func factorial<T: BinaryInteger>(_ n: T) -> Int? {
        if n < 0 {
            return nil
        }
        return Int(tgamma(Double(n+1)))
    }

    /**
     Calculate `n!` for values of `n` that conform to the BinaryFloatingPoint
     protocol.  Uses the gamma function to "fill in" values of `n` that are
     not integers.  Returns `nil` if `n` is less than zero.
     */
    public static func factorial<T: BinaryFloatingPoint>(_ n: T) -> Double? {
        if n < 0 {
            return nil
        }
        return Double(tgamma(Double(n+1)))
    }

    /**
     Calculate n-choose-k for values of `n` and `k` that conform to the BinaryInteger
     protocol.
     */
    public static func choose<T: BinaryInteger>(n: T, k: T) -> Int {
        return Int(tgamma(Double(n + 1)))/Int(tgamma(Double(k + 1))*tgamma(Double(n - k + 1)))
    }

    /**
     Calculate n-choose-k for values of `n` that conform to the BinaryFloatingPoint
     protocol and values of `k` that conform to the BinaryInteger protocol.
     */
    public static func choose<N: BinaryFloatingPoint, K: BinaryInteger>(n: N, k: K) -> Double {
        return Double(tgamma(Double(n + 1)))/Double(tgamma(Double(k + 1))*tgamma(Double(Double(n) - Double(k) + 1)))
    }

    
    /**
     Calculates the mean of an array of values for types that satisfy the
     BinaryInteger protocol (e.g Int, Int32).
     
     - Parameters:
        - data: Array of values
     
     - Returns:
        The mean of the array of values or `nil` if the array was empty.
     */
    public static func mean<T: BinaryInteger>(_ data: [T]) -> Double? {
        if data.count == 0 {
            return nil
        }
        return Double(data.reduce(0, +))/Double(data.count)
    }

    /**
     Calculates the mean of an array of values for types that satisfy the
     BinaryFloatingPoint protocol (e.g Float, Double).
     
     - Parameters:
        - data: Array of values
     
     - Returns:
     The mean of the array of values or `nil` if the array was empty.
     */
    public static func mean<T : BinaryFloatingPoint>(_ data: [T]) -> Double? {
        if data.count == 0 {
            return nil
        }
        return Double(data.reduce(0, +))/Double(data.count)
    }

    
    /**
     Calculates the unbiased sample variance for an array for types that satisfy
     the BinaryFloatingPoint protocol (e.g Float, Double).
     
     - Parameters:
        - data:
        Sample of values.  Note that this should contain at least two values.
     
     - Returns:
        The unbiased sample variance or `nil` if `data` contains fewer than two
        values.
     */
    public static func variance<T: BinaryFloatingPoint>(_ data: [T]) -> Double? {
        if data.count < 2 {
            return nil
        }
        
        guard let m = mean(data) else {
            return nil // This shouldn't ever occur
        }
        var total = 0.0
        for i in 0..<data.count {
            total += pow(Double(data[i]) - m,2)
        }
        return total/Double(data.count-1)
    }
    
    /**
     Calculates the unbiased sample standard deviation for an array of values
     for types that satisfy the BinaryFloatingPoint protocol (e.g Float, Double).
     
     - Parameters:
        - data:
        Sample of values.  Note that this should contain at least two values.
     
     - Returns:
        The sample unbiased standard deviation or `nil` if `data` contains fewer
        than two values.
     */
    public static func sd<T: BinaryFloatingPoint>(_ data: [T]) -> Double? {
        guard let v = variance(data) else {
            return nil
        }
        return sqrt(v)
    }
    
    /**
     Calculates the unbiased sample standard deviation for an array of values
     for types that satisfy the BinaryInteger protocol (e.g Int, Int32).
     
     - Parameters:
        - data:
        Sample of values.  Note that this should contain at least two values.
     
     - Returns:
     The sample unbiased standard deviation or `nil` if `data` contains fewer
     than two values.
     */
    public static func sd<T: BinaryInteger>(_ data: [T]) -> Double? {
        guard let v = variance(data) else {
            return nil
        }
        return sqrt(v)
    }

    /**
     Calculates the population variance for an array of values for types that
     satisfy the BinaryFloatingPoint protocol (e.g Float, Double).
     
     - Parameters:
        - data:
        Values of population.  Note that this should contain at least one value.
     
     - Returns:
     The population variance or `nil` if `data` contains fewer than one value.
     */
    public static func pvariance<T: BinaryFloatingPoint>(_ data: [T]) -> Double? {
        if data.count < 1 {
            return nil
        }
        guard let m = mean(data) else {
            return nil // This shouldn't ever occur
        }
        var total = 0.0
        for i in 0..<data.count {
            total += pow(Double(data[i]) - m,2)
        }
        return total/Double(data.count)
    }

    /**
     Calculates the unbiased sample variance for an array of values for types
     that satisfy the BinaryInteger protocol (e.g Int, Int32).
     
     - Parameters:
        - data:
        Sample of values.  Note that this should contain at least two values.
     
     - Returns:
     The unbiased sample variance or `nil` if `data` contains fewer than two
     values.
     */
    public static func variance<T: BinaryInteger>(_ data: [T]) -> Double? {
        if data.count < 2 {
            return nil
        }
        
        guard let m = mean(data) else {
            return nil // This shouldn't ever occur
        }
        var total = 0.0
        for i in 0..<data.count {
            total += pow(Double(data[i]) - m,2)
        }
        return total/Double(data.count-1)
    }

    /**
     Calculates the population variance for an array of values for types that
     satisfy the BinaryInteger protocol (e.g Int, Int32).
     
     - Parameters:
        - data:
        Values of population.  Note that this should contain at least one value.
     
     - Returns:
     The population variance or `nil` if `data` contains fewer than one value.
     */
    public static func pvariance<T: BinaryInteger>(_ data: [T]) -> Double? {
        guard let m = mean(data) else {
            return nil
        }
        var total = 0.0
        for i in 0..<data.count {
            total += pow(Double(data[i]) - m,2)
        }
        return total/Double(data.count)
    }
    
    /**
     Calculates the median of an array of values for types that
     satisfy the BinaryFloatingPoint protocol (e.g Float, Double).
     
     - Parameters:
        - data:
        Values of population.  Note that this should contain at least one value.
     
     - Returns:
     The population variance or `nil` if `data` contains fewer than one value.
     */
    public static func median<T: BinaryFloatingPoint>(_ data: [T]) -> Double? {
        if data.isEmpty {
            return nil
        }
        let sorted_data = data.sorted()
        if data.count % 2 == 1 {
            return Double(sorted_data[Int(floor(Double(data.count)/2))])
        }
        else {
            return Double(sorted_data[data.count/2]+sorted_data[(data.count/2)-1])/2
        }
    }
    
    /**
     Calculates the median of an array of values for types that
     satisfy the BinaryInteger protocol (e.g Int, Int32).
     
     - Parameters:
        - data:
        Values of population.  Note that this should contain at least one value.
     
     - Returns:
     The population variance or `nil` if `data` contains fewer than one value.
     */
    public static func median<T: BinaryInteger>(_ data: [T]) -> Double? {
        if data.isEmpty {
            return nil
        }
        let sorted_data = data.sorted()
        if data.count % 2 == 1 {
            return Double(sorted_data[Int(floor(Double(data.count)/2))])
        }
        else {
            return Double(sorted_data[data.count/2]+sorted_data[(data.count/2)-1])/2
        }
    }

   
    public static func erfinv(_ y: Double) -> Double {
        let center = 0.7
        let a = [ 0.886226899, -1.645349621,  0.914624893, -0.140543331]
        let b = [-2.118377725,  1.442710462, -0.329097515,  0.012229801]
        let c = [-1.970840454, -1.624906493,  3.429567803,  1.641345311]
        let d = [ 3.543889200,  1.637067800]
        if abs(y) <= center {
            let z = pow(y,2)
            let num = (((a[3]*z + a[2])*z + a[1])*z) + a[0]
            let den = ((((b[3]*z + b[2])*z + b[1])*z + b[0])*z + 1.0)
            var x = y*num/den
            x = x - (erf(x) - y)/(2.0/sqrt(pi)*exp(-x*x))
            x = x - (erf(x) - y)/(2.0/sqrt(pi)*exp(-x*x))
            return x
        }

        else if abs(y) > center && abs(y) < 1.0 {
            let z = pow(-log((1.0-abs(y))/2),0.5)
            let num = ((c[3]*z + c[2])*z + c[1])*z + c[0]
            let den = (d[1]*z + d[0])*z + 1
            // should use the sign public static function instead of pow(pow(y,2),0.5)
            var x = y/pow(pow(y,2),0.5)*num/den
            x = x - (erf(x) - y)/(2.0/sqrt(pi)*exp(-x*x))
            x = x - (erf(x) - y)/(2.0/sqrt(pi)*exp(-x*x))
            return x
        }

        else if abs(y) == 1 {
            return y*Double(Int.max)
        }

        else {
            // this should throw an error instead
            return Double.nan
        }
    }

    public static func lsr(_ points: [[Double]]) -> [Double] {
        var total_x = 0.0
        var total_xy = 0.0
        var total_y = 0.0
        var total_x2 = 0.0
        for i in 0..<points.count {
            total_x += points[i][0]
            total_y += points[i][1]
            total_xy += points[i][0]*points[i][1]
            total_x2 += pow(points[i][0], 2)
        }
        let N = Double(points.count)
        let b = (N*total_xy - total_x*total_y)/(N*total_x2 - pow(total_x, 2))
        let a = (total_y - b*total_x)/N
        return [a, b]
    }

}
