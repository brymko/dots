#!/bin/bash

set -e

actions_script="./actions.sh"
if [ "$(uname -s)" = "Darwin" ]; then
    actions_script="./actions_macos.sh"
fi

"$actions_script" uninstall