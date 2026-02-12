#!/bin/bash

# Global variables
var="I am GLOBAL"
docker_version="V1.1"

echo "--- 1. Testing local variables (Protected) ---"
echo "Before func_local: var=$var, docker_version=$docker_version"

func_local() {
    local var="I am LOCAL"
    local docker_version="V2.0"
    echo "Inside func_local: var=$var, docker_version=$docker_version"
}

func_local
echo "After func_local:  var=$var, docker_version=$docker_version"

echo -e "\n--- 2. Testing global/regular variables (Leaking) ---"

func_global() {
    var="I have been OVERWRITTEN"
    docker_version="V3.0"
    new_var="I am a new global"
    echo "Inside func_global: var=$var, docker_version=$docker_version"
}

func_global
echo "After func_global:  var=$var, docker_version=$docker_version, new_var=$new_var"

