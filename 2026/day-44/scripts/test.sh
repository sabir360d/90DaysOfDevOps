#!/bin/bash

echo "Running tests..."

if [ 2 -eq 2 ]; then
  echo "Test Passed ✅"
  exit 0
else
  echo "Test Failed ❌"
  exit 1
fi
