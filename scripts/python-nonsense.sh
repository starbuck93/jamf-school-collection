#!/bin/bash

#Why do I have so many pythons in my system???

which pip
which pip3
which python
which python3

ls -lha $(which pip)
ls -lha $(which pip3)
ls -lha $(which python)
ls -lha $(which python3)

# echo $PATH
# for each in path, separated by ":", try to find which pip and which python
IFS=':' read -ra ADDR <<< "$PATH"
for i in "${ADDR[@]}"; do
    # echo "Checking directory: $i"
    if [ -f "$i/pip" ]; then
        echo "Found pip at $i/pip"
    fi
    if [ -f "$i/python" ]; then
        echo "Found python at $i/python"
    fi
done

# for each in path, separated by ":", try to find which pip3 and which python3
IFS=':' read -ra ADDR <<< "$PATH"
for i in "${ADDR[@]}"; do
    # echo "Checking directory: $i"
    if [ -f "$i/pip3" ]; then
        echo "Found pip3 at $i/pip3"
    fi
    if [ -f "$i/python3" ]; then
        echo "Found python3 at $i/python3"
    fi
done
echo "---"
echo "---"
pythons=("/Users/astarbuck/Library/Python/3.9/bin/pip" "/opt/homebrew/bin//pip3" "/Users/astarbuck/Library/Python/3.9/bin/pip3" "/usr/bin/pip3" "/usr/local/bin/python" "/opt/homebrew/bin//python3" "/usr/bin/python3")

for python in "${pythons[@]}"; do
    echo "Location: $python"
    echo "---------" "$($python --version)"
done