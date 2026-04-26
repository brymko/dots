log() {
    echo "$1"
}

resolve_source_path() {
    local source_dir source_name
    source_dir="$(cd "$(dirname "$1")" && pwd -P)"
    source_name="$(basename "$1")"
    printf '%s/%s\n' "$source_dir" "$source_name"
}

create_symlink() {
    ln -s "$(resolve_source_path "$1")" "$2"
}

drop_file() {
    local source_path
    source_path="$(resolve_source_path "$1")"

    if [[ -L "$2" ]]; then
        if [[ "$source_path" -ef "$2" ]]; then
            log "$2 already links to $source_path"
            return 0
        fi
        rm "$2"
    elif [[ -e "$2" ]]; then
        mv "$2" "$2.bak"
    fi

    create_symlink "$1" "$2"
}

restore_file() {
    if [[ -f "$1.bak" ]]; then
        mv "$1.bak" "$1"
    elif [[ -L "$1" ]]; then
        rm "$1"
    fi
}
