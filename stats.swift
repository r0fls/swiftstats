import Foundation

class Discrete {
	// this should never happen;
	// will occur if a class inherits this class without
	// defining an overriding Quantile method. 
	func Quantile(p: Double) -> Int {
		return -1*Int.max
	}
	func random() -> Int {
		return self.Quantile(Double(drand48()))
	}
}

class Continuous {
	// see Discrete class
	func Quantile(p: Double) -> Double {
		return -1*Double(Int.max)
	}
	func random() -> Double {
		return self.Quantile(Double(drand48()))
	}
}

class Bernoulli: Discrete {
	var p: Double

	init(p: Double) {
		self.p = p
	}
	convenience init(data: [Int]) {
		self.init(p: mean(data))
	}
	func Pmf(k: Int) -> Double {
		if k == 1 {
			return self.p
		}
		if k == 0 {
			return 1 - self.p
		}
		return -1
	}	
	func Cdf(k: Int) -> Double {
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
	override func Quantile(p: Double) -> Int {
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

class Laplace: Continuous {
	var mean: Double
	var b: Double	

	init (mean: Double, b: Double) {
		self.mean = mean	       
		self.b = b
	}
	func pdf(x: Double) -> Double {
		return exp(-abs(x - self.mean)/self.b)/2
	}
	func Cdf(x: Double) -> Double {
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
	override func Quantile(p: Double) -> Double {
		if p > 0 && p <= 0.5 {
			return self.mean + self.b*log(2*p)
		}
		if p > 0.5 && p < 1 {
			return self.mean - self.b*log(2*(1-p))
		}
		return -1
	}
}

class Poisson: Discrete {
	        var mean: Double
		init(mean: Double) {
			self.mean = mean
		}

		func Pmf(k: Int) -> Double {
			return pow(self.mean, Double(k))*exp(-self.mean)/tgamma(Double(k+1))
		}
		func Cdf(k: Int) -> Double {
			var total = Double(0)
			for i in 1..<k+1 {
				total += self.Pmf(i)
			}
			return total
		}
		override func Quantile(x: Double) -> Int {
			var total = Double(0)
			var j = 0
			while total < x {
				j += 1
				total += self.Pmf(j)
			}
			return j
		}
}

class Geometric: Discrete {
	var p: Double
	init(p: Double) {
		self.p = p
	}

	func Pmf(k: Int) -> Double {
		return pow(1 - self.p, Double(k - 1))*self.p
	}
	func Cdf(k: Int) -> Double {
		return 1 - pow(1 - self.p, Double(k))
	}
	override func Quantile(p: Double) -> Int {
		return Int(ceil(log(1 - p)/log(1 - self.p)))
	}
}

class Exponential: Continuous {
	var l: Double
	init(l: Double) {
		self.l = l
	}

	func pdf(x: Double) -> Double {
		return self.l*exp(-self.l*x)
	}
	func Cdf(x: Double) -> Double {
		return 1 - exp(-self.l*x)
	}
	override func Quantile(p: Double) -> Double {
		return -log(1 - p)/self.l
	}
}

class Binomial: Discrete {
	var n: Int
	var p: Double
	init(n: Int, p: Double) {
		self.n = n
		self.p = p
	}

	func Pmf(k: Int) -> Double {
		let r = Double(k)
		return Double(choose(self.n, k: k))*pow(self.p, r)*pow(1 - self.p, Double(self.n - k))
	}
	func Cdf(k: Int) -> Double {
		var total = Double(0)
		for i in 1..<k + 1 {
			total += self.Pmf(i)
		}
		return total
	}
	override func Quantile(x: Double) -> Int {
		var total = Double(0)
		var j = 0
		while total < x {
			j += 1
			total += self.Pmf(j)
		}
		return j
	}
}

class Normal: Continuous {
	var mean: Double
	var variance: Double
	let pi = M_PI
	init(mean: Double, variance: Double) {
		self.mean = mean
		self.variance = variance
	}

	func Pdf(x: Double) -> Double {
		return (1/pow(self.variance*2*pi,0.5))*exp(-pow(x-self.mean,2)/(2*variance))
	}
	
	func Cdf(x: Double) -> Double {
		return (1 + erf((x-self.mean)/pow(2*self.variance,0.5)))/2
	}
}
// COMMON FUNCTIONS
func factorial(n: Int) -> Int {
	return Int(tgamma(Double(n+1)))
}

func choose(n: Int, k: Int) -> Int {
	return Int(tgamma(Double(n + 1)))/Int(tgamma(Double(k + 1))*tgamma(Double(n - k + 1)))
}

func mean(data: [Int]) -> Double {
	return Double(data.reduce(0, combine: +))/Double(data.count)
}

func mean(data: [Double]) -> Double {
	return Double(data.reduce(0, combine: +))/Double(data.count)
}

func mean(data: [Float]) -> Double {
	return Double(data.reduce(0, combine: +))/Double(data.count)
}

func variance(data: [Double]) -> Double {
	let m = mean(data)
	var total = 0.0
	for i in 0..<data.count {
		total += pow(data[i] - m,2)
	}
	return total/Double(data.count-1)
}

func pvariance(data: [Double]) -> Double {
	let m = mean(data)
	var total = 0.0
	for i in 0..<data.count {
		total += pow(data[i] - m,2)
	}
	return total/Double(data.count)
}

func variance(data: [Int]) -> Double {
	let m = mean(data)
	var total = 0.0
	for i in 0..<data.count {
		total += pow(Double(data[i]) - m,2)
	}
	return total/Double(data.count-1)
}

func pvariance(data: [Int]) -> Double {
	let m = mean(data)
	var total = 0.0
	for i in 0..<data.count {
		total += pow(Double(data[i]) - m,2)
	}
	return total/Double(data.count)
}

func median(data: [Int]) -> Double {
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

func median(data: [Double]) -> Double {
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

func median(data: [Float]) -> Float {
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

func erfinv(y: Double) -> Double {
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
		// should use the sign function instead of pow(pow(y,2),0.5)
	        var x = y/pow(pow(y,2),0.5)*num/den
		x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
		x = x - (erf(x) - y)/(2.0/sqrt(M_PI)*exp(-x*x))
		return x
	}
	else {
		// this should throw an error instead
		return Double(-Int.max)
	}
}
// EXAMPLE DATA (should eventually move to tests)

/*
let b = Bernoulli(p: 0.7)
print(b.Pmf(1)) // 0.7
print(b.Cdf(1)) // 1.0 
print(b.Cdf(0)) // 0.3
print(b.Quantile(0.5)) // 1
print(b.Quantile(0.2)) // 1
print(b.random()) // 1

let l = Laplace(mean: 0.0, b: 1.0)
print(l.pdf(1))
print(l.random())
print(l.Cdf(1))
print(l.Cdf(0))

let p = Poisson(mean: 1.5)
print(p.Pmf(3))
print(p.Cdf(1))
print(p.Cdf(0))
print(p.Quantile(0.5))
print(p.random())

let g = Geometric(p: 0.5)
print(g.Pmf(3))
print(g.Cdf(3))
print(g.Cdf(4))
print(g.Quantile(0.9999))
print(g.random())

let e = Exponential(l: 0.5)
print(e.pdf(3))
print(e.Cdf(3))
print(e.Cdf(4))
print(e.Quantile(0.9999))
print(e.random())
let b = Bernoulli(data: [1,1,0,1])
print(b.p)
print(b.random())
*/
print(erfinv(erf(2.0)))
//let n = Normal(mean: 0.0, variance: 3)
//print(n.Cdf(pow(3,0.5))-n.Cdf(-pow(3,0.5)))
