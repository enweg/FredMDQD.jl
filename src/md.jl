function load_fred_md(fred_md::DataFrame)
    fred_md = drop_missing_row(fred_md)
    tcodes = Int.(collect(fred_md[1, 2:end]))  # first column is the date
    original = fred_md[2:end, :]  # first two rows are transformation code and factor boolean
    if length(split(original[1, 1], "/")[3]) < 4
        @warn "FRED MD dates are ambiguous. I will therefore keep them as string"
    else
        original[!, 1] = Date.(original[:, 1], dateformat"mm/dd/yyyy")
    end
    transformed = copy(original)
    for c=2:size(transformed, 2)
        transformed[!, c] = fred_transform(Val(tcodes[c-1]), transformed[:, c])
    end
    return (original = original, tcodes = tcodes, transformed = transformed)
end

"""
    FredMD(path::String)
    FredMD(d::Date)
    FredMD()

Load Fred MD data. 

## Arguments 

- `path::String`: Path to a manually downloaded version of Fred MD. 
- `d::Date`: Date of a vintage.

## Details

- If no arguments are provided, the most recent version of Fred MD will be downloaded. 
- If a `d::Date` is provided, the Fred MD vintage corresponding to the date will be downloaded. 
- If a `path::String` is provided, then the Fred MD file at the `path` will be loaded. 

## Notes

- Fred MD data is compiled by Michael W. McCracken at the Federal Reserve Bank of St. Louis. For more information check out the official website at https://research.stlouisfed.org/econ/mccracken/fred-databases/

"""
struct FredMD
    original::DataFrame
    transformed::DataFrame
    tcodes::Vector{Union{Missing, Int64}}

    function FredMD(path::String)
        fred_md = CSV.read(path, DataFrame)
        original, tcodes, transformed = load_fred_md(fred_md)
        new(original, transformed, tcodes)
    end

    function FredMD(d::Date)
        vintage = Dates.format(d, dateformat"yyyy-mm")
        urls = [
            "https://files.stlouisfed.org/files/htdocs/fred-md/monthly/$(vintage).csv", 
            "https://www.stlouisfed.org/-/media/project/frbstl/stlouisfed/research/fred-md/monthly/$(vintage).csv"
        ]
        for url in urls
            try
                fred_md = CSV.read(download(url), DataFrame)
                original, tcodes, transformed = load_fred_md(fred_md)
                return new(original, transformed, tcodes)
            catch 
                continue
            end
        end
        error("Could not download Fred MD data for vintage $(vintage).")
    end 

    function FredMD()
        @info "Retrieving the most recent FRED MD data. \n For publishable research it is better to specify the vintage using FredMD(d::Date)."
        url = "https://www.stlouisfed.org/-/media/project/frbstl/stlouisfed/research/fred-md/monthly/current.csv"
        fred_md = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_md(fred_md)
        new(original, transformed, tcodes)
    end
end

