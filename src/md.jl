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
        url = "https://files.stlouisfed.org/files/htdocs/fred-md/monthly/$(vintage).csv"
        fred_md = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_md(fred_md)
        new(original, transformed, tcodes)
    end 

    function FredMD()
        @info "Retrieving the most recent FRED MD data. \n For publishable research it is better to specify the vintage using FredMD(d::Date)."
        url = "https://files.stlouisfed.org/files/htdocs/fred-md/monthly/current.csv"
        fred_md = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_md(fred_md)
        new(original, transformed, tcodes)
    end
end

