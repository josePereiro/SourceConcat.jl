function concat(;
        cfg = SourceConcat.load_config(), 
        log = true
    )

    _validate_config(cfg; log) || return
    paths = collect_paths(;cfg, log)
    lines = concat_lines(paths; cfg, log)
    
    out_mode = get(cfg, "output.mode", "file")
    if out_mode == "terminal"
        for line in lines
            println(line)
        end
    elseif out_mode == "clipboard-text"
        text = join(lines, "\n")
        clipboard_text(text; limit=200_000)
        return
    elseif out_mode == "clipboard-file"
        base = get(cfg, "__config.base", pwd())
        output_file = get(cfg, "output.path", "SourceConcat.md")
        output_path = _canonicalize(output_file; base)
        write_output(output_path, lines; log)
        clipboard_file(output_path; log)
        return
    elseif out_mode == "file"
        base = get(cfg, "__config.base", pwd())
        output_file = get(cfg, "output.path", "SourceConcat.md")
        output_path = _canonicalize(output_file; base)
        write_output(output_path, lines; log)
        return
    else
        log && @error "Unknown out_mode" out_mode
    end

end