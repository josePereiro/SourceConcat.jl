## ..- . -- -.- .- -. - --. .-. -. .- -
# walkdir and filer by path
function collect_paths(;
        cfg = SourceConcat.load_config(), 
        verbose = false
    )
    
    base = get(cfg, "__config.base", pwd())
    roots = get(cfg, "root.paths", String[])
    include_globs = get(cfg, "include.files", String[])
    include_globs = Glob.FilenameMatch.(include_globs)
    exclude_globs = get(cfg, "exclude.files", String[])
    exclude_globs = Glob.FilenameMatch.(exclude_globs)

    paths = String[]

    for root in roots
        root = _canonicalize(root; base)
        for (dir, _, files) in walkdir(root)

            for file in files

                path = joinpath(dir, file)
                rel = relpath(path, root)
                
                # Include/Exclude filter
                _exc = _match_anyglob(rel, exclude_globs)
                if _exc
                    verbose && @info(
                        "Excluding!!", 
                        rel, 
                        reason = "Match 'exclude.files'"
                    )
                    continue
                end

                _inc = isempty(include_globs)
                if _inc
                    verbose && @info(
                        "Including!!", 
                        rel, 
                        reason = "'include.files' empty"
                    )
                    push!(paths, path)
                    continue
                end

                _inc = _match_anyglob(rel, include_globs)
                if _inc
                    verbose && @info(
                        "Including!!", 
                        rel, 
                        reason = "Match 'include.files'"
                    )
                    push!(paths, path)
                    continue
                end

            end
        end
    end

    unique!(paths)
    return paths
end

