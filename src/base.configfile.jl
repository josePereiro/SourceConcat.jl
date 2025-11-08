# ------------------------------------------------------------------
# Utility: read JSON allowing comments and trailing commas
# ------------------------------------------------------------------
function _read_json_with_comments(path::AbstractString)
    text = read(path, String)
    # # Remove // and /* */ comments (non-greedy for block comments)
    text = replace(text, r"\s*//.*$" => "")
    return JSON3.read(text, Dict{String, Any})
end

# ------------------------------------------------------------------
# Public API
# ------------------------------------------------------------------

CONFIG_FILE_NAMES = [
    "SourceConcat.json", 
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
        _raw = _read_json_with_comments(path)
        for (k, v) in _raw
            _cfg[string(k)] = v
        end
        
        # Meta
        _cfg["__config.name"] = name
    end

    if log && !_found
        @warn "Configuration file not found." base=base action="Using empty default configuration."
    end

    
    # Meta
    _cfg["__config.base"] = base

    return _cfg
end
