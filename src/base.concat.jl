function concat(;
        cfg = SourceConcat.load_config(),
        verbose = false
    )
    
    paths = collect_paths(;cfg)
    
    lines = SourceConcat.concat_lines(paths)
    
    if verbose
        for line in lines
            println(line)
        end
    end

    
    out_mode = get(cfg, "output.mode", "file")
    if out_mode == "clipboard-text"
        text = join(lines, "\n")
        SourceConcat.clipboard_text(text; limit=200_000)
        return
    elseif out_mode == "clipboard-file"
        base = get(cfg, "__config.base", pwd())
        output_file = get(cfg, "output.path", "SourceConcat.md")
        output_path = _canonicalize(output_file; base)
        write_output(output_path, lines)
        clipboard_file(output_path)
        return
    elseif out_mode == "file"
        base = get(cfg, "__config.base", pwd())
        output_file = get(cfg, "output.path", "SourceConcat.md")
        output_path = _canonicalize(output_file; base)
        write_output(output_path, lines)    
        return
    else
        @error "Unknown out_mode" out_mode
    end

end