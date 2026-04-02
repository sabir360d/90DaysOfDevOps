#!/bin/bash

# Function: greet
greet() {
    local name="$1"
    echo "Hello, $name!"
}

# Function: add
add() {
    local num1="$1"
    local num2="$2"
    echo "Sum: $((num1 + num2))"
}

# Calling functions
greet "Sabir"
add 1 2

