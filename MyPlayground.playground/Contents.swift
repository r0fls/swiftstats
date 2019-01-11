//: Playground - noun: a place where people can play

import SwiftStats
import Foundation

var b = SwiftStats.Distributions.Bernoulli(p: 0.7)
print(b.pmf(1)) // 0.7
print(b.cdf(1)) // 1.0
print(b.cdf(0)) // 0.3
print(b.quantile(0.5)) // 1
print(b.quantile(0.2)) // 0 */
//b.seed()
print(b.random()) // 0
b = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])!
//print(b.p)
print(b.random())


var l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
print(l.pdf(1))
srand48(0)
print(round(pow(10.0,15.0)*l.random())/pow(10.0,15.0))
print(l.cdf(1))
print(l.cdf(0))

l = SwiftStats.Distributions.Laplace(data:[12,13,12])!
//print(l.mean)

var p = SwiftStats.Distributions.Poisson(m: 1.5)
print(p.pmf(3))
print(p.cdf(1))
print(p.cdf(0))
srand48(0)
print(p.quantile(0.5))
dump(p.random(4))

p = SwiftStats.Distributions.Poisson(data: [1,2,3])!
//print(p.m)
print(p.quantile(0.999))

let g = SwiftStats.Distributions.Geometric(p: 0.5)
print(g.pmf(3))
print(g.cdf(3))
print(g.cdf(4))
print(g.quantile(0.9999))
srand48(0)
print(g.random())

let e = SwiftStats.Distributions.Exponential(l: 0.5)
print(e.pdf(3))
print(e.cdf(3))
print(e.cdf(4))
print(e.quantile(0.5))
print(e.random())

print(SwiftStats.Common.erfinv(erf(1.4)))
print(SwiftStats.Common.erfinv(-1))

// Normal Distribution
var n = SwiftStats.Distributions.Normal(mean: 0.0, sd: 1)
print(n.cdf(1.96))
print(n.quantile(0.975))
print(n.pdf(0))
print(n.quantile(n.cdf(3)))
print(n.random())

// Normal from array
n = SwiftStats.Distributions.Normal(data: [1,2,1,0,1,2])!

// Log-normal Distribution
var ln = SwiftStats.Distributions.LogNormal(meanLog: 0.0, sdLog: 1)
print(ln.cdf(1))
print(ln.quantile(0.7558914))
print(ln.pdf(1))
print(ln.quantile(ln.cdf(3)))
print(ln.random())

// Log-Normal from array
ln = SwiftStats.Distributions.LogNormal(data: [1,2,3])!

// Uniform Distribution
let u = SwiftStats.Distributions.Uniform(a:5,b:10)
print(u.random())
