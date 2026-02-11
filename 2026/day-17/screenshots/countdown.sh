#!/bin/bash

echo "Enter a number:"
read number

while [ "$number" -ge 0 ]
do
    echo "Countdown: $number"
    number=$((number - 1))
done

echo "Done!"

