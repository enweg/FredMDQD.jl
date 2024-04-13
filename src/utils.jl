function drop_missing_row(df::DataFrame)
    all_missing = map(row -> all(map(ismissing, row)), eachrow(df))
    return df[(!).(all_missing), :]
end
