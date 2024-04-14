# FredMDQD

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://enweg.github.io/FredMDQD.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://enweg.github.io/FredMDQD.jl/dev/)
[![Build Status](https://github.com/enweg/FredMDQD.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/enweg/FredMDQD.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/enweg/FredMDQD.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/enweg/FredMDQD.jl)

## What is FredMDQD? 

`FredMDQD` simplifies the process of working with Fred MD or Fred QD data.

## What are Fred MD and Fred QD?

[Fred MD and Fred QD](https://research.stlouisfed.org/econ/mccracken/fred-databases/) are curated sets of monthly and quarterly indicators by Michael W. McCracken at the Federal Reserve Bank of St. Louis. Fred MD comprises 126 monthly indicators, while Fred QD consists of 245 quarterly indicators.Observations start in January 1959 for Fred MD and in Q1 1959 for Fred QD. 


## How do I load Fred MD or Fred QD data? 

`FredMDQD` offers straightforward methods to load Fred MD/QD data. The simplest approach loads the most recent version of either dataset. 

```julia
using FredMDQD
using DataFrames

fmd = FredMD()  # Loads most recent version of Fred MD
fqd = FredQD()  # Loads most recent version of Fred QD
```

The returned objects contain: 

- `original::DataFrame`: Untouched Fred MD/QD data. 
- `transformed::DataFrame`: Data transformed according to McCracken's recommended stationarity adjustments.
- `tcodes::Vector{Int}`: Transformation codes for each variable except the date. More information on transformation codes can be found using `@doc FredMDQD.fred_transform`

For loading specific vintage data, provide a date as an argument: 

```julia
using Dates

d = Date("2022/03", dateformat"yyyy/mm")
fmd = FredMD(d)
fqd = FredQD(d)
```

Manual downloads of Fred MD/QD data can be loaded using file paths: 

```julia
path_md = "path to manual download of Fred MD"
path_qd = "path to manual download of Fred QD"
fmd = FredMD(path_md)
fqd = FredQD(path_qd)
```


## What does a variable mean? 

Fred MD/QD use abbreviations for variables that are not always intuitive. To find the meaning behind an abbreviation, or to find an abbreviation corresponding to a specific indicator, the `seach_appendix` function can be used. `search_appendix` searches through the Fred MD/QD appendices to find a specific search term. For example, Fred MD includes the indicator 'DPCERA3M086SBEA'. To find the meaning behind this indicator, run 

```julia
search_appendix(:MD, "DPCERA3M086SBEA")
```

This returns a `DataFrame` of search results matching the search criteria. The indicator 'DPCERA3M086SBEA' corresponds to "Real personal consumption expenditures". 

Similarly, to find an indicator in Fred QD corresponding to house prices, search for 'house' to see if any such indicators exist.

```julia 
search_appendix(:QD, "house")
```

The search results indicate that Fred QD includes USSTHPI corresponding to "All-Transactions House Price Index for the United States (Index 1980 Q1=100)". 

## Where can I find more information? 

For additional details, visit the official [Fred MD/QD website.](https://research.stlouisfed.org/econ/mccracken/fred-databases/) 
