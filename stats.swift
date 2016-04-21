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

