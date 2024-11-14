#!/usr/bin/env bash
    filename="$*"
    dirname="${filename/\./_}"
    pkgutil --expand "$filename" "$dirname"
    cd "$dirname"/*.pkg || exit
    tar xzvf Payload
    open .
