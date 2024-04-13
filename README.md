# FredMDQD

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://enweg.github.io/FredMDQD.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://enweg.github.io/FredMDQD.jl/dev/)
[![Build Status](https://github.com/enweg/FredMDQD.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/enweg/FredMDQD.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/enweg/FredMDQD.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/enweg/FredMDQD.jl)

## What is FredMDQD? 

`FredMDQD` aims to make working with Fred MD and Fred QD data easy. It started as a small weekend project consisting of a set of scripts and evolved into a stand-alone package. 

## What are Fred MD and Fred QD?

[Fred MD and Fred QD](https://research.stlouisfed.org/econ/mccracken/fred-databases/) are pre-compiled sets of monthly and quarterly indicators respectively. Both are compiled and maintained by Michael W. McCracken at the Federal Reserve Bank of St. Louis. Fred MD consists of 126 monthly indicators, while Fred QD consists of 245 quarterly indicators. The earliest observations for Fred MD are from January 1959 while the earliest observations for Fred QD are from Q1 1959. 


## How do I load Fred MD or Fred QD data? 

`FredMDQD` provides various ways to load Fred MD and Fred QD data. The easiest is to just load the current version of either of the data sets. This can be done using the following lines. 

```julia
using FredMDQD
using DataFrames

fmd = FredMD()  # Loads most recent version of Fred MD
fqd = FredQD()  # Loads most recent version of Fred QD
```

`FredMD` and `FredQD` return a struct containing the following: 

- `original::DataFrame`: Fred MD/QD data in without transformations. 
- `transformed::DataFrame`: McCracken provides recommended transformation to make each variable stationary. The `transformed` DataFrame uses these recommended transformations. 
- `tcodes::Vector{Int}`: provides the transformation codes used for each variable except the date column. The corresponding mathematical transformations are privided in `@doc fred_transform`. 

`FredMDQD` also allows for loading a specific vintage of Fred MD/QD. This can be achieved by providing a date as an argument. To obtain the vintage from March 2022, the following code can be used.

```julia
using Dates

d = Date("2022/03", dateformat"yyyy/mm")
fmd = FredMD(d)
fqd = FredQD(d)
```

Lastly, if manual download of either Fred MD or QD exits, then `FredMDQD` can be used to load this manual download by providing a path to the file. 

```julia
path_md = "path to manual download of Fred MD"
path_qd = "path to manual download of Fred QD"
fmd = FredMD(path_md)
fqd = FredQD(path_qd)
```


## What does a variable mean? 

Fred MD/QD use abbreviations for variables that are not always intuitive. To find the meaning behind an abbreviation, or to find an abbreviation corresponding to a specific indicator, the `seach_appendix` function can be used. `search_appendix` searches through the Fred MD/QD appendices to find a specific search term. For example, Fred MD include the indicator DPCERA3M086SBEA. To find the meaning behind this indicator, we can run 

```julia
search_appendix(:MD, "DPCERA3M086SBEA")
```

This returns a `DataFrame` search results matching our criteria. The indicator DPCERA3M086SBEA corresponds to "Real personal consumption expenditures". 

Similarly, if we wanted to find an indicator in Fred QD corresponding to house prices, we can search for 'house' to see if any such indicator exists.

```julia 
search_appendix(:QD, "house")
```

Thus, Fred QD includes USSTHPI corresponding to "All-Transactions House Price Index for the United States (Index 1980 Q1=100)". 

## Where can I find more information? 

More information can be found at the offical website for [Fred MD and Fred QD](https://research.stlouisfed.org/econ/mccracken/fred-databases/). 
