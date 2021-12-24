#!/bin/bash

set -eou pipefail


proc_qemu=$(pgrep -a qemu)
if [ "$#" -eq 1 ]; then
    proc_qemu=$(echo "$proc_qemu" | grep -v grep | grep "$1")
fi

port=$(echo "$proc_qemu" | sed -r 's/^.*-spice.*port=([0-9]+),.*$/\1/g')

if [[ ! -f "$HOME/vm/preload/xigd.so" ]]; then
    pushd "$HOME/vm/preload"
    echo $(pwd)
    make || exit 1
    popd
fi

while true
do
    out=$(LD_PRELOAD="$HOME/vm/preload/xigd.so" remote-viewer -v spice://127.0.0.1:$port)
    if [[ $out =~ "Could not connect" ]]; then
        exit 0
    elif [[ $out =~ "has disconnected" ]]; then
        continue
    else
        echo "$out"
        exit 1
    fi
done
