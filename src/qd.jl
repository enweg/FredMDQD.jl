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
        url = "https://files.stlouisfed.org/files/htdocs/fred-md/quarterly/$(vintage).csv"
        fred_qd = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_qd(fred_qd)
        new(original, transformed, tcodes)
    end

    function FredQD()
        @info "Retrieving the most recent FRED QD data. \n For publishable research it is better to specify the vintage using FredQD(d::Date)."
        url = "https://files.stlouisfed.org/files/htdocs/fred-md/quarterly/current.csv"
        fred_qd = CSV.read(download(url), DataFrame)
        original, tcodes, transformed = load_fred_qd(fred_qd)
        new(original, transformed, tcodes)
    end
end