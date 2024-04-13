APPENDIX_PATH = artifact"FredMDQD"


function search_appendix(path, needle; case_sensitive=false)
    appendix = CSV.read(path, DataFrame)
    if !isa(needle, Regex)
        needle = case_sensitive ? Regex(needle) : Regex(needle, "i")
    end
    m = map(x -> contains.(string.(x), needle), eachcol(appendix))
    m = reduce(hcat, m)
    m = map(any, eachrow(m))
    return(appendix[m, :])
end

search_appendix(s::Symbol, args...; kwargs...) = search_appendix(Val(s), args...; kwargs...)

function search_appendix(::Val{:QD}, needle; case_sensitive=false, historic=false)
    path_current = joinpath(APPENDIX_PATH, "FRED-QD-Appendix", "FRED-QD_updated_appendix.csv")
    path_historic = joinpath(APPENDIX_PATH, "FRED-QD-Appendix", "FRED-QD_historic_appendix.csv")
    path = historic ? path_historic : path_current
    return search_appendix(path, needle; case_sensitive=case_sensitive)
end

function search_appendix(::Val{:MD}, needle; case_sensitive=false, historic=false)
    path_current = joinpath(APPENDIX_PATH, "FRED-MD-Appendix", "FRED-MD_updated_appendix.csv")
    path_historic = joinpath(APPENDIX_PATH, "FRED-MD-Appendix", "FRED-MD_historic_appendix.csv")
    path = historic ? path_historic : path_current
    return search_appendix(path, needle; case_sensitive=case_sensitive)
end
