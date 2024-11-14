#!/usr/bin/env bash

# use this script to unpack a PKG file into its base components
    filename="$*"
    dirname="${filename/\./_}"
    pkgutil --expand "$filename" "$dirname"
    cd "$dirname"/*.pkg || exit
    tar xzvf Payload
    open .
