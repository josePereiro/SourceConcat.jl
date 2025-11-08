## ..- . -- -.- .- -. - --. .-. -. .- -
# walkdir and filer by path
# walkdir and filter by path
function collect_paths(; cfg = SourceConcat.load_config(),
                       log::Bool = true,
                       log_detail::Bool = false)

    base = get(cfg, "__config.base", pwd())
    roots = get(cfg, "root.paths", String[])
    include_globs = get(cfg, "include.files", String[])
    include_globs = Glob.FilenameMatch.(include_globs)
    exclude_globs = get(cfg, "exclude.files", String[])
    exclude_globs = Glob.FilenameMatch.(exclude_globs)

    paths = String[]
    inc_by_include = 0
    inc_by_empty   = 0
    exc_by_exclude = 0

    log && @info "Scanning roots for files." roots=length(roots) base=base include_patterns=length(include_globs) exclude_patterns=length(exclude_globs)

    for root in roots
        root = _canonicalize(root; base)
        log && @info "Walking root." root=root
        for (dir, _, files) in walkdir(root)
            for file in files
                path = joinpath(dir, file)
                rel  = relpath(path, root)

                # Exclude filter
                if _match_anyglob(rel, exclude_globs)
                    exc_by_exclude += 1
                    log_detail && @info "Excluding" rel=rel reason="match exclude.files"
                    continue
                end

                # Include logic
                if isempty(include_globs)
                    inc_by_empty += 1
                    log_detail && @info "Including" rel=rel reason="include.files empty"
                    push!(paths, path)
                    continue
                end

                if _match_anyglob(rel, include_globs)
                    inc_by_include += 1
                    log_detail && @info "Including" rel=rel reason="match include.files"
                    push!(paths, path)
                    continue
                end
            end
        end
    end

    unique!(paths)
    log && @info "Collected paths." total=length(paths) included_by_match=inc_by_include included_by_empty=inc_by_empty excluded_by_match=exc_by_exclude unique=true
    return paths
end
