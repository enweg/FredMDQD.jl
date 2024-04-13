# Artifacts for FredMDQD.jl

Artifact files contain additional information used for the main library.

## Notes

- Appendix for Fred MD and Fred QD were downloaded from https://research.stlouisfed.org/econ/mccracken/fred-databases/ at 15:00 13/04/2024

## How to create artifacts.tar.gz

First, run the following two commands to create the `tar.gz` file.

1. `rm artifacts.tar.gz`
2. `tar -czvf artifacts.tar.gz *`

Next, run the following Julia commands. 

```julia
using Tar, Inflate, SHA

filename = "artifacts.tar.gz"
println("sha256: ", bytes2hex(open(sha256, filename)))
println("git-tree-sha1: ", Tar.tree_hash(IOBuffer(inflate_gzip(filename))))
```

Use the output of the Julia code above to adjust the `Artifacts.toml` file in the `main` repo. 

