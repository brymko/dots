#!/bin/bash

set -e

os_name="$(uname -s)"
actions_script="./actions.sh"
if [ "$os_name" = "Darwin" ]; then
    actions_script="./actions_macos.sh"
fi

# https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "options:"
            echo "-d, --deps, --install_deps   installs Linux dependencies for the Linux dotfiles setup"
            exit 0
            ;;
        -d|--deps|--install_deps)
            shift
            if [ "$os_name" = "Darwin" ]; then
                echo "macOS dependency installation is not implemented"
                exit 1
            fi
            "$actions_script" install deps
            exit 0
            ;;
        *)
          break
          ;;
      esac
done

"$actions_script" install