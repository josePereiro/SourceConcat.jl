# ------------------------------------------------------------------
# Public API
# ------------------------------------------------------------------

CONFIG_FILE_NAMES = [
    "SourceConcat.jsonc", 
    "SourceConcat.json", 
    "SrcConcat.jsonc", 
    "SrcConcat.json", 
]

"""
    load_config(; path="SrcConcat.json") -> Dict{String,Any}

Load configuration from a JSON file (with optional comments).
If the file is missing, loads an empty Dict.
Updates and returns the module's current config.
"""
function load_config(;
        base::AbstractString = pwd(),
        names::Vector = CONFIG_FILE_NAMES, 
        log = true
    )
    
    _cfg = Dict{String,Any}()
    _found = false
    for name in names
        path = joinpath(base, name)
        isfile(path) || continue
        _found = true
        # Meta
        _read_json_with_comments!(_cfg, path)
        _cfg["__config.name"] = name
    end

    if log && !_found
        @warn "Configuration file not found." base=base action="Using empty default configuration."
    end

    
    # Meta
    _cfg["__config.base"] = base

    return _cfg
end
