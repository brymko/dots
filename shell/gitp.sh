#!/bin/bash

PROMPT=""
cur_status=$(git status -s -b --ignored 2>/dev/null || exit 0)

add_file_status() {
    files=$(echo "$cur_status" | grep "$1")
    files_count=$(echo "$files" | grep "$1" | wc -l)
    if [[ "$files_count" -gt 0 ]]; then
        PROMPT="$PROMPT %F{cyan}$2$files_count"
    fi
}

# modified
add_file_status "^.M" "*"
# untracked
add_file_status "^??" "+"
# ignored
# add_file_status "^!!" "!"
# removed
add_file_status "^.D" "-"
# renamed
add_file_status "^.R" "r"

if [[ $(echo "$cur_status" | grep "^[M|A]") ]]; then
    PROMPT="$PROMPT %F{red}staged"
fi

branch=$(echo "$cur_status" | head -n 1 | cut -d ' ' -f 2 | cut -d '.' -f 1)
PROMPT="$PROMPT %F{green}$branch"

ahead=$(echo "$cur_status" | perl -n -e '/ahead (\d+)]/ && print $1')
if [[ "$ahead" -gt 0 ]]; then
    PROMPT="$PROMPT %F{red}ahead %F{magenta}$ahead"
fi
behind=$(echo "$cur_status" | perl -n -e '/behind (\d+)]/ && print $1')
if [[ "$behind" -gt 0 ]]; then
    PROMPT="$PROMPT %F{red}behind %F{magenta}$behind"
fi

echo "$PROMPT"
