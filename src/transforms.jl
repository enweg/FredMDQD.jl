"""
return x
"""
function fred_transform(::Val{1}, x)
  return x
end

"""
return Δx
"""
function fred_transform(::Val{2}, x)
  return vcat(missing, x[2:end] - x[1:(end-1)])
end

"""
return Δ²x
"""
function fred_transform(::Val{3}, x)
  x = fred_transform(Val(2), x)
  return fred_transform(Val(2), x)
end

"""
return log(x)
"""
function fred_transform(::Val{4}, x)
  return log.(x)
end

"""
return Δlog(x)
"""
function fred_transform(::Val{5}, x)
  x = fred_transform(Val(4), x)
  return fred_transform(Val(2), x)
end

"""
return Δ²log(x)
"""
function fred_transform(::Val{6}, x)
  x = fred_transform(Val(4), x)
  return fred_transform(Val(3), x)
end

"""
return Δ(xₜ₊₁ / xₜ - 1)
"""
function fred_transform(::Val{7}, x)
  x = vcat(missing, x[2:end] ./ x[1:(end-1)] .- 1)
  return fred_transform(Val(2), x)
end

@doc raw"""
Apply a FRED tranformation code

## Arguments

- `tcode`: FRED transformation code
- `x`: a vector of data

## Transformation Codes

The following transformation codes are currently supported

1. ``x``
2. ``\Delta x``
3. ``\Delta^2 x``
4. ``log(x)``
5. ``\Delta log(x)``
6. ``\Delta^2 log(x)``
7. ``Δ(x_{t+1} / x_t - 1)
"""
fred_transform(tcode::Int, x) = fred_transform(Val(tcode), x)
