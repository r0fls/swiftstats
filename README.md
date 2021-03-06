[![Build Status](https://travis-ci.org/r0fls/swiftstats.png)](https://travis-ci.org/r0fls/swiftstats)
# SwiftStats
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# swiftstats
Statistics for Swift &mdash; v1.6.3

Wanting to generate a random number with a specific distribution for your iOS app?  Or smooth out your data using kernel density estimation?  SwiftStats has you covered.  

SwiftStats is open-source with automated testing and automatically-generated documentation.  If you'd like to help out we'd welcome contributions.

## Features
### Distributions
Currently the following distributions are included: 
- Normal
- Log-normal
- Bernoulli 
- Laplace 
- Poisson
- Uniform
- Geometric
- Exponential
- Binomial

And each distribution has these methods:
- pmf or pdf
- cdf
- quantile
- random (takes an optional int and returns an array of that length, or otherwise a single value) 

### Common Functions
- median
- mean
- variance
- standard deviation
- erf<sup>-1</sup> (implemented as `erfinv`, whereas `erf` is implemented as part of `Foundation`)
- least squares regression; lsr ([[`Double`]]) -> [`Double`, `Double`]
- kernel density estimation (KDE) using a Gaussian kernel and automatic bandwidth selection via Silverman's rule-of-thumb

## Documentation

Documentation for the functions and classes in SwiftStats is automatically generated using [Jazzy](https://github.com/realm/jazzy).

You can view the documentation on our [GitHub site](http://r0fls.github.io/swiftstats/), and it is included in each release.

If you wish to reprocess the documentation yourself, it is as simple as running `jazzy` from the command line.


## Building

There are two options for building SwiftStats; you can use Carthage to build and update the framework for you, or you can manually clone SwiftStats from GitHub and build it yourself. 

### Building with Carthage

Using Carthage to manage to build process and to update the framework is the ideal option for those who wish to use the latest stable version of SwiftStats.

First, ensure that [Carthage](https://github.com/Carthage/Carthage) is installed.  Using Terminal, navigate to your project's directory.  Edit or add a the file named `Cartfile`.  The contents should include the line

    github "r0fls/swiftstats"

From Terminal, run the command 

    carthage update

This will download the latest stable release and build the framework.

Next, follow the [rest of the instructions](https://github.com/Carthage/Carthage#getting-started).


### Manual Build

Using the manual build process is ideal for those who want the latest (not necessarily stable) version.  It's especially relevant for those who would like to contribute.

From Terminal, clone the repo using the command:
    
    git clone https://github.com/r0fls/swiftstats.git
    
In Xcode, open the project file `SwiftStats.xcodeproj`.  Select a target, and compile by selecting Product > Build.
    

## Testing

 Open the project (top level directory for the entire repo) in Xcode. The repo includes a playground, which has all of the examples from the unit tests. You can run the unit tests in Xcode (Product > Test), or by opening a terminal, changing to the directory of the repo, and typing:

    xcodebuild test -scheme SwiftStats

## Example Usage

Start by importing the library:

```swift

import SwiftStats
```

To print a random number that is normally distributed with a mean of 0 and a variance of 1:

```swift
let n1 = SwiftStats.Distributions.Normal(m:0, v:1.0)
print(n1.random())
```

To print a random number that is normally distributed, with parameters based on previous samples:

```swift
let n2 = SwiftStats.Distributions.Normal(data:[0,-1,1,0])
print(n2.random())
```

To find the median of some data:

```swift
let median1 = SwiftStats.Common.median([1,4,3,2]) // -> 2.5
let median2 = SwiftStats.Common.median([3,1,2]) // -> 2
```

### Advanced
You can make the number produced by the `random()` methods predictable by supplying a known seed to a seedable random number generator.  By default the system provided random number generator is used, which is automatically seeded.

```swift
let n3 = SwiftStats.Distributions.Normal(m:0, v:1.0)

// A randomly-generated number from a Normal distribution, using the
// system's random number generator
let rand1 = n3.random()
print(rand1)

// A randomly-generated number from a Normal distribution, using a
// user-provided random number generator
var rng = SwiftStats.SeedableRandomNumberGenerator(seed: 42)
let rand2 = n3.random(using: &rng)
print(rand2)
```

## Contributing
If you would like to contribute, please submit a pull request, or raise an issue.

### TO-DO
- improve documentation coverage from the current 39%.
- add more distributions
- allow updating a fitted distribution with more data
- pass travis tests without mangling the median function
- other stuff

## License
All code that I created in this repository (which is everything that was not generated by Xcode from a template, including the main source and the Unit Tests) is licensed under [CC0](https://creativecommons.org/publicdomain/zero/1.0/), which means that it is part of the public domain and you can do anything with it, without asking permission. In places where Xcode automatically attributed copyright to Raphael Deem or Matthew Walker, this overrides that.
