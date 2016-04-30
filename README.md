# swiftstats
Statistics for swift

### Setup
Clone the repo:
    
    git clone https://github.com/r0fls/swiftstats.git

Then open the project (top level directory for the entire repo) in Xcode. The repo includes a playground, which has all of the examples from the unit tests. You can run the unit tests by opening a terminal, changing to the directory of the repo, and typing:

    xcodebuild test -scheme SwiftStats

### Example
```swift

import SwiftStats

let  n = SwiftStats.Distributions.Normal(0, 1.0)
print(n.random())
    
// or fit a distribution from data...
n = SwiftStats.Distributions.Normal([0,-1,1,0])
print(b.random())
```
###Features
####Distributions
Currently the following distributions are included: 
- Normal
- Bernoulli 
- Laplace 
- Poisson
- Uniform
- Geometric
- Exponential
- Binomial

And each distribution has these methods:
- Pmf or Pdf
- Cdf
- Quantile
- Random (takes an optional int and returns an array of that length, or otherwise a single value) 

####Common Functions
- median (`Int`, `Float`, `Double`)
- mean (`Int`, `Float`, `Double`)
- erf<sup>-1</sup> (implemented as `erfinv`, whereas `erf` is implemented as part of `Foundation`)

#####Common Function Example
```swift
import SwiftStats
SwiftStats.Common.Median([1,4,3,2]) // -> 2.5
SwiftStats.Common.Median([3,1,2]) // -> 2
```

#####Advanced
You can seed the random variable by using `srand48()`, or leave it to use the default seed:
```swift
n = Normal(0, 1.0)
print(n.random())
n.seed(42)
print(n.random())
```

###Contributing
If you're interested in contributing, please submit a pull request, or raise an issue.

#####TO-DO
- add more distributions
- allow updating a fitted distribution with more data
