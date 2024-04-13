function drop_missing_row(df::DataFrame)
    all_missing = map(row -> all(map(ismissing, row)), eachrow(df))
    return df[(!).(all_missing), :]
end

"""
Provide information about `FredMDQD`.
"""
function info()
    rootpath = artifact"FredMDQD"
    path = joinpath(rootpath, "info.md")
    info_text = read(path, String)
    print(info_text)
end
