#!/bin/sh
set -euo pipefail

if [ ! -f "$(command -v "flameshot")" ]; then
    echo "ss tool (import) not found"
    exit 1
fi

flameshot gui 
