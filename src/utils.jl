## ..- . -- -.- .- -. - --. .-. -. .- -
# util for mathing many globs to a single path
function _match_anyglob(path::String, fms::Vector{<:Glob.FilenameMatch})
    for fm in fms
        ismatch(fm, path) && return true
    end
    return false
end

function _canonicalize(path; base=pwd())
    p = expanduser(path)
    p = isabspath(p) ? p : abspath(base, p)
    p = normpath(p)  # tidy but don't require existence
    return p
end

function clipboard_text(text::AbstractString; 
        limit::Int=200_000, log::Bool=true
    )
    n = ncodeunits(text)
    if n > limit
        log && @warn "String too long; not copying to clipboard." bytes=n limit=limit
        return false
    else
        clipboard(text)
        log && @info "Copied text to clipboard." bytes=n
        return true
    end
end

function write_output(
    path::AbstractString, lines::Vector{<:AbstractString}; 
    log::Bool=true
)
    try
        mkpath(dirname(path))
        open(path, "w") do io
            for line in lines
                println(io, line)
            end
        end
        sz = filesize(path)
        log && @info "Wrote output file." path=abspath(path) lines=length(lines) bytes=sz
        return path
    catch err
        log && @error "Failed to write output file." path=abspath(path) exception=(err, catch_backtrace())
        rethrow()
    end
end



function common_prefix(paths::Vector{<:AbstractString})
    isempty(paths) && return ""
    parts = splitpath.(paths)
    minlen = minimum(length, parts)
    prefix = String[]
    for i in 1:minlen
        segment = parts[1][i]
        all(p -> p[i] == segment, parts) || break
        push!(prefix, segment)
    end
    return joinpath(prefix...)
end
