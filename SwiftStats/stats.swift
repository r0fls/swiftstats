import Foundation

 public struct Distributions {
	// these two classes shouldn't really be public because they're only used internally,
	// but the distriubutions are public and require they're parents to be
	public class Discrete {
		// this should never happen; but will happen if called directly
		// or if a class inherits this class without
		// defining an overriding Quantile method
		public func Quantile(p: Double) -> Int {
			return -Int.max
		}
		
        // single discrete random value
        public func random() -> Int {
			return self.Quantile(Double(drand48()))
		}
        
        // array of discrete random values
        public func random(n: Int) -> [Int] {
            var results: [Int] = []
            for _ in 0..<n {
                results.append(self.random())
            }
            return results
        }
	}

	public class Continuous {
		// see Discrete public class
		public func Quantile(p: Double) -> Double {
			return -1*Double.NaN
		}

        // single continuous random value
        public func random() -> Double {
			return self.Quantile(Double(drand48()))
		}
        // array of discrete random values
        public func random(n: Int) -> [Double] {
            var results: [Double] = []
            for _ in 0..<n {
                results.append(self.random())
            }
            return results
        }
	}

	public class Bernoulli: Discrete {
		var p: Double

		public init(p: Double) {
			self.p = p
		}
		public convenience init(data: [Int]) {
			self.init(p: Common.mean(data))
		}
		public func Pmf(k: Int) -> Double {
			if k == 1 {
				return self.p
			}
			if k == 0 {
				return 1 - self.p
			}
			return -1
		}	
		public func Cdf(k: Int) -> Double {
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
		override public func Quantile(p: Double) -> Int {
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

	public class Laplace: Continuous {
		var mean: Double
		var b: Double	

		public init (mean: Double, b: Double) {
			self.mean = mean	       
			self.b = b
		}

		public convenience init(data: [Double]) {
			let m = Common.median(data)
			var b = 0.0
			for i in 0..<data.count {
				b += abs(data[i] - m)
			}
			b = b/Double(data.count)
			self.init(mean: m, b: b)
		}

		public func Pdf(x: Double) -> Double {
			return exp(-abs(x - self.mean)/self.b)/2
		}

		public func Cdf(x: Double) -> Double {
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

		override public func Quantile(p: Double) -> Double {
			if p > 0 && p <= 0.5 {
				return self.mean + self.b*log(2*p)
			}
			if p > 0.5 && p < 1 {
				return self.mean - self.b*log(2*(1-p))
			}
			return -1
		}
	}

	public class Poisson: Discrete {
		var m: Double
		public init(m: Double) {
			self.m = m
		}

		public convenience init(data: [Double]) {
			self.init(m: Common.mean(data))
		}

		public func Pmf(k: Int) -> Double {
			return pow(self.m, Double(k))*exp(-self.m)/tgamma(Double(k+1))
		}

		public func Cdf(k: Int) -> Double {
			var total = Double(0)
			for i in 0..<k+1 {
				total += self.Pmf(i)
			}
			return total
		}

		override public func Quantile(x: Double) -> Int {
			var total = Double(0)
			var j = 0
			total += self.Pmf(j)
			while total < x {
				j += 1
				total += self.Pmf(j)
			}
			return j
		}
	}

	public class Geometric: Discrete {
		var p: Double
		public init(p: Double) {
			self.p = p
		}

		public convenience init(data: [Double]) {
			self.init(p: 1/Common.mean(data))
		}

		public func Pmf(k: Int) -> Double {
			return pow(1 - self.p, Double(k - 1))*self.p
		}

		public func Cdf(k: Int) -> Double {
			return 1 - pow(1 - self.p, Double(k))
		}

		override public func Quantile(p: Double) -> Int {
			return Int(ceil(log(1 - p)/log(1 - self.p)))
		}
	}

	public class Exponential: Continuous {
		var l: Double
		public init(l: Double) {
			self.l = l
		}

		public convenience init(data: [Double]) {
			self.init(l: 1/Common.mean(data))
		}

		public func Pdf(x: Double) -> Double {
			return self.l*exp(-self.l*x)
		}

		public func Cdf(x: Double) -> Double {
			return 1 - exp(-self.l*x)
		}

		override public func Quantile(p: Double) -> Double {
			return -log(1 - p)/self.l
		}
	}

	public class Binomial: Discrete {
		var n: Int
		var p: Double
		public init(n: Int, p: Double) {
			self.n = n
			self.p = p
		}

		public func Pmf(k: Int) -> Double {
			let r = Double(k)
			return Double(Common.choose(self.n, k: k))*pow(self.p, r)*pow(1 - self.p, Double(self.n - k))
		}
		public func Cdf(k: Int) -> Double {
			var total = Double(0)
			for i in 1..<k + 1 {
				total += self.Pmf(i)
			}
			return total
		}
		override public func Quantile(x: Double) -> Int {
			var total = Double(0)
			var j = 0
			while total < x {
				j += 1
				total += self.Pmf(j)
			}
			return j
		}
	}

	public class Normal: Continuous {
		// mean and variance
		var m: Double
		var v: Double
		let pi = M_PI

		public init(m: Double, v: Double) {
			self.m = m
			self.v = v
		}

		public convenience init(data: [Double]) {
			// this calculates the mean twice, since variance()
			// uses the mean and calls mean()
			self.init(m: Common.mean(data), v: Common.variance(data))
		}

		public func Pdf(x: Double) -> Double {
			return (1/pow(self.v*2*pi,0.5))*exp(-pow(x-self.m,2)/(2*self.v))
		}

		public func Cdf(x: Double) -> Double {
			return (1 + erf((x-self.m)/pow(2*self.v,0.5)))/2
		}

		override public func Quantile(p: Double) -> Double {
			return self.m + pow(self.v*2,0.5)*Common.erfinv(2*p - 1)
		}
	}

	public class Uniform: Continuous {
		// a and b are endpoints, that is  
		// values will be distributed uniformly between points a and b
		var a: Double
		var b: Double

		public init(a: Double, b: Double) {
			self.a = a
			self.b = b
		}

		public func Pdf(x: Double) -> Double {
			if x>a && x<b {
				return 1/(b-a)
			}
			return 0
		}

		public func Cdf(x: Double) -> Double {
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

		override public func Quantile(p: Double) -> Double {
			if p>=0 && p<=1{
				return p*(b-a)+a
			}
			return Double.NaN
		}
	}
}
// COMMON FUNCTIONS
public struct Common {
	public static func factorial(n: Int) -> Int {
		return Int(tgamma(Double(n+1)))
	}

	public static func choose(n: Int, k: Int) -> Int {
		return Int(tgamma(Double(n + 1)))/Int(tgamma(Double(k + 1))*tgamma(Double(n - k + 1)))
	}

	public static func mean(data: [Int]) -> Double {
		return Double(data.reduce(0, combine: +))/Double(data.count)
	}

	public static func mean(data: [Double]) -> Double {
		return Double(data.reduce(0, combine: +))/Double(data.count)
	}

	public static func mean(data: [Float]) -> Double {
		return Double(data.reduce(0, combine: +))/Double(data.count)
	}

	public static func variance(data: [Double]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(data[i] - m,2)
		}
		return total/Double(data.count-1)
	}

	public static func pvariance(data: [Double]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(data[i] - m,2)
		}
		return total/Double(data.count)
	}

	public static func variance(data: [Int]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(Double(data[i]) - m,2)
		}
		return total/Double(data.count-1)
	}

	public static func pvariance(data: [Int]) -> Double {
		let m = mean(data)
		var total = 0.0
		for i in 0..<data.count {
			total += pow(Double(data[i]) - m,2)
		}
		return total/Double(data.count)
	}

	public static func median(data: [Int]) -> Double {
		let sorted_data = data.sort()
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

	public static func median(data: [Double]) -> Double {
		let sorted_data = data.sort()
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

	public static func median(data: [Float]) -> Float {
		let sorted_data = data.sort()
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

	public static func erfinv(y: Double) -> Double {
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
			x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
			x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
			return x
		}
		else if abs(y) > center && abs(y) < 1.0 {
			let z = pow(-log((1.0-abs(y))/2),0.5)
			let num = ((c[3]*z + c[2])*z + c[1])*z + c[0]
			let den = (d[1]*z + d[0])*z + 1
			// should use the sign public static function instead of pow(pow(y,2),0.5)
			var x = y/pow(pow(y,2),0.5)*num/den
			x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
			x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
			return x
		}
		else if abs(y) == 1 {
			return y*Double(Int.max)
		}
		else {
			// this should throw an error instead
			return Double.NaN
		}
	}
}