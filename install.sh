#!/bin/bash

set -e

# https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "options:"
            echo "-d, --install_deps        installs all missing programs for which dots are dropped"
            exit 0
            ;;
        -d)
            shift 
            ./actions install install_deps
            exit 0
            ;;
        --install_deps)
            shift
            ./actions install install_deps
            ;;
        *)
          break
          ;;
      esac
done

./actions.sh install 
