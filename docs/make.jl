using FredMDQD
using Documenter

DocMeta.setdocmeta!(FredMDQD, :DocTestSetup, :(using FredMDQD); recursive=true)

makedocs(;
    modules=[FredMDQD],
    authors="Enrico Wegner",
    sitename="FredMDQD.jl",
    format=Documenter.HTML(;
        canonical="https://enweg.github.io/FredMDQD.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/enweg/FredMDQD.jl",
    devbranch="main",
)
