import Foundation

// COMMON FUNCTIONS
public struct Common {
    private static let pi = Double.pi
    
	public static func factorial(_ n: Int) -> Int {
		return Int(tgamma(Double(n+1)))
	}

	public static func choose(_ n: Int, k: Int) -> Int {
		return Int(tgamma(Double(n + 1)))/Int(tgamma(Double(k + 1))*tgamma(Double(n - k + 1)))
	}

	public static func mean(_ data: [Int]) -> Double {
		return Double(data.reduce(0, +))/Double(data.count)
	}

	public static func mean(_ data: [Double]) -> Double {
		return Double(data.reduce(0, +))/Double(data.count)
	}

	public static func mean(_ data: [Float]) -> Double {
		return Double(data.reduce(0, +))/Double(data.count)
	}

	public static func variance(_ data: [Double]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(data[i] - m,2)
		}
		return total/Double(data.count-1)
	}

	public static func pvariance(_ data: [Double]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(data[i] - m,2)
		}
		return total/Double(data.count)
	}

	public static func variance(_ data: [Int]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(Double(data[i]) - m,2)
		}
		return total/Double(data.count-1)
	}

	public static func pvariance(_ data: [Int]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(Double(data[i]) - m,2)
		}
		return total/Double(data.count)
	}

	public static func median(_ data: [Int]) -> Double {
		let sorted_data = data.sorted()
		if data.count % 2 == 1 {
			return Double(sorted_data[Int(floor(Double(data.count)/2))]) 
		}
		else if data.count % 2 == 0 && data.count != 0 {
			return Double(sorted_data[data.count/2]+sorted_data[(data.count/2)-1])/2
		}
		// 0 length array would return this;
		else {
			return -Double(Int.max)
		}
	}

	public static func median(_ data: [Double]) -> Double {
		let sorted_data = data.sorted()
		if data.count % 2 == 1 {
			return sorted_data[Int(floor(Double(data.count)/2))]
		}
		else if data.count % 2 == 0 && data.count != 0 {
			return (sorted_data[data.count/2]+sorted_data[(data.count/2)-1])/2
		}
		// 0 length array would return this;
		else {
			return -Double(Int.max)
		}
	}

	public static func median(_ data: [Float]) -> Float {
		let sorted_data = data.sorted()
		if data.count % 2 == 1 {
			return sorted_data[Int(floor(Double(data.count)/2))] 
		}
		else if data.count % 2 == 0 && data.count != 0 {
			return (sorted_data[data.count/2]+sorted_data[(data.count/2)-1])/2
		}
		else {
			return -Float(Int.max)
		}
	}
    
    public static func logArray(_ data: [Double]) -> [Double] {
        var result: [Double] = data
        for i in stride(from: 0, to: result.count, by: 1) {
            result[i] = log(result[i])
        }
        return result
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
