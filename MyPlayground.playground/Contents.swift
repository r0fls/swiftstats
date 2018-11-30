//: Playground - noun: a place where people can play

//import UIKit
import SwiftStats
import Foundation

//srand48(0)
var b = SwiftStats.Distributions.Bernoulli(p: 0.7)
print(b.Pmf(1)) // 0.7
print(b.Cdf(1)) // 1.0
print(b.Cdf(0)) // 0.3
print(b.quantile(0.5)) // 1
print(b.quantile(0.2)) // 0 */
//b.seed()
print(b.Random()) // 0
b = SwiftStats.Distributions.Bernoulli(data: [1,1,0,1])
//print(b.p)
print(b.Random())


var l = SwiftStats.Distributions.Laplace(mean: 0.0, b: 1.0)
print(l.Pdf(1))
srand48(0)
print(round(pow(10.0,15.0)*l.Random())/pow(10.0,15.0))
print(l.Cdf(1))
print(l.Cdf(0))

l = SwiftStats.Distributions.Laplace(data:[12,13,12])
//print(l.mean)

var p = SwiftStats.Distributions.Poisson(m: 1.5)
print(p.Pmf(3))
print(p.Cdf(1))
print(p.Cdf(0))
srand48(0)
print(p.quantile(0.5))
dump(p.Random(4))

p = SwiftStats.Distributions.Poisson(data: [1,2,3])
//print(p.m)
print(p.quantile(0.999))

let g = SwiftStats.Distributions.Geometric(p: 0.5)
print(g.Pmf(3))
print(g.Cdf(3))
print(g.Cdf(4))
print(g.quantile(0.9999))
srand48(0)
print(g.Random())

let e = SwiftStats.Distributions.Exponential(l: 0.5)
print(e.Pdf(3))
print(e.Cdf(3))
print(e.Cdf(4))
print(e.quantile(0.5))
print(e.Random())

print(SwiftStats.Common.erfinv(erf(1.4)))
print(SwiftStats.Common.erfinv(-1))

// Normal Distribution
var n = SwiftStats.Distributions.Normal(mean: 0.0, sd: 1)
print(n.Cdf(1.96))
print(n.quantile(0.975))
print(n.Pdf(0))
print(n.quantile(n.Cdf(3)))
print(n.Random())

// Normal from array
n = SwiftStats.Distributions.Normal(data: [1,2,1,0,1,2])

// Log-normal Distribution
var ln = SwiftStats.Distributions.LogNormal(meanLog: 0.0, sdLog: 1)
print(ln.Cdf(1))
print(ln.quantile(0.7558914))
print(ln.Pdf(1))
print(ln.quantile(ln.Cdf(3)))
print(ln.Random())

// Log-Normal from array
ln = SwiftStats.Distributions.LogNormal(data: [1,2,3])

// Uniform Distribution
let u = SwiftStats.Distributions.Uniform(a:5,b:10)
print(u.Random())
