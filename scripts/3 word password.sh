#!/bin/bash

# Download a dictionary file if not already downloaded
DICTIONARY_URL="https://www.mit.edu/~ecprice/wordlist.10000"
DICTIONARY_FILE="/tmp/words.txt"

if [ ! -f "$DICTIONARY_FILE" ]; then
  curl -s "$DICTIONARY_URL" -o "$DICTIONARY_FILE"
fi

# Count the number of words in the dictionary
WORD_COUNT=$(wc -l < "$DICTIONARY_FILE")

# Generate three random numbers and save them to separate variables
NUM1=$(( RANDOM ))
NUM2=$(( RANDOM ))
NUM3=$(( RANDOM ))

# Output the numbers
# echo "Random Number 1: $NUM1"
# echo "Random Number 2: $NUM2"
# echo "Random Number 3: $NUM3"


# Generate three distinct random words
WORD1=$(awk "NR == $(( NUM1 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")
WORD2=$(awk "NR == $(( NUM2 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")
WORD3=$(awk "NR == $(( NUM3 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")

# Combine words with dashes
PASSWORD="$WORD1-$WORD2-$WORD3"

echo "$PASSWORD"
