#!/bin/sh

set -euo pipefail

NAME=$(date +"%s%N")
FILE="$HOME/pics/$NAME.png"

if [ ! -f "$(command -v "import")" ]; then
    echo "ss tool (import) not found"
    exit 1
fi

import "$FILE" 2>&1 1>/dev/null

