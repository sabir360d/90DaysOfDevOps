#
##!/bin/bash
#set -euo pipefail
#
#echo "Script started"
#echo "----------------------------"
#
#test_number="${1:-1}"
#
#case "$test_number" in
#    1)
#        echo "Test 1: set -u (Undefined variable)"
#        echo "Value: $UNDEFINED_VAR"
#        ;;
#    2)
#        echo "Test 2: set -e (Failing command)"
#        ls /directory-that-does-not-exist
#        ;;
#    3)
#        echo "Test 3: set -o pipefail (Pipeline failure)"
#        echo "hello" | grep "world"
#        ;;
#    *)
#        echo "Usage: ./strict_demo.sh [1|2|3]"
#        exit 1
#        ;;
#esac
#
#echo "Script completed"
#
#

#!/usr/bin/env bash
set -euo pipefail

echo "Script started"
echo "----------------------------"

# Use first argument or default to 1
test_number="${1:-1}"

# Replace case/esac with if/elif/else/fi
if [[ "$test_number" == "1" ]]; then
    echo "Test 1: set -u (Undefined variable)"
    echo "Value: $UNDEFINED_VAR"

elif [[ "$test_number" == "2" ]]; then
    echo "Test 2: set -e (Failing command)"
    ls /directory-that-does-not-exist

elif [[ "$test_number" == "3" ]]; then
    echo "Test 3: set -o pipefail (Pipeline failure)"
    echo "hello" | grep "world"

else
    echo "Usage: ./strict_demo.sh [1|2|3]"
    exit 1
fi

echo "Script completed"

