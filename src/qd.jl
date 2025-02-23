function load_fred_qd(fred_qd::DataFrame)
    fred_qd = drop_missing_row(fred_qd)
    tcodes = Int.(collect(fred_qd[2, 2:end]))  # first column is the date
    original = fred_qd[3:end, :]  # first two rows are transformation code and factor boolean
    if length(split(original[1, 1], "/")[3]) < 4
        @warn "FRED QD dates are ambiguous. I will therefore keep them as string"
    else
        original[!, 1] = Date.(original[:, 1], dateformat"mm/dd/yyyy")
    end
    transformed = copy(original)
    for c = 2:size(transformed, 2)
        transformed[!, c] = fred_transform(Val(tcodes[c-1]), transformed[:, c])
    end
    return (original=original, tcodes=tcodes, transformed=transformed)
end


"""
    FredQD(path::String)
    FredQD(d::Date)
    FredQD()

Load Fred QD data. 

## Arguments 

- `path::String`: Path to a manually downloaded version of Fred QD. 
- `d::Date`: Date of a vintage.

## Details

- If no arguments are provided, the most recent version of Fred QD will be downloaded. 
- If a `d::Date` is provided, the Fred QD vintage corresponding to the date will be downloaded. 
- If a `path::String` is provided, then the Fred QD file at the `path` will be loaded. 

## Notes

- Fred QD data is compiled by Michael W. McCracken at the Federal Reserve Bank of St. Louis. For more information check out the official website at https://research.stlouisfed.org/econ/mccracken/fred-databases/

"""
struct FredQD
    original::DataFrame
    transformed::DataFrame
    tcodes::Vector{Union{Missing,Int64}}

    function FredQD(path::String)
        fred_qd = CSV.read(path, DataFrame)
        original, tcodes, transformed = load_fred_qd(fred_qd)
        new(original, transformed, tcodes)
    end

    function FredQD(d::Date)
        vintage = Dates.format(d, dateformat"yyyy-mm")
        urls = [
            "https://files.stlouisfed.org/files/htdocs/fred-md/quarterly/$(vintage).csv", 
            "https://www.stlouisfed.org/-/media/project/frbstl/stlouisfed/research/fred-md/quarterly/$(vintage).csv"
        ]
        for url in urls
            try
                fred_qd = CSV.read(download(url), DataFrame)
                original, tcodes, transformed = load_fred_qd(fred_qd)
                return new(original, transformed, tcodes)
            catch
                continue
            end
        end
        error("Could not download Fred QD data for vintage $(vintage).")
    end

    function FredQD()
        @info "Retrieving the most recent FRED QD data. \n For publishable research it is better to specify the vintage using FredQD(d::Date)."
        url = "https://www.stlouisfed.org/-/media/project/frbstl/stlouisfed/research/fred-md/quarterly/current.csv"
        fred_qd = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_qd(fred_qd)
        new(original, transformed, tcodes)
    end
end
