
#!/bin/bash

function render() {
    sed -r "s|\{\{\s*java_version\s*\}\}|${1}|" ${2}
}

function main() {
    versions=(8 11 17)
    mkdir -p dockerfiles
    for version in ${versions[*]}; do
        mkdir -p dockerfiles/openjdk${version} && \
        cp -r ./assets ./dockerfiles/openjdk${version} && \
        render "${version}" "Dockerfile.template" > ./dockerfiles/openjdk${version}/Dockerfile || exit 1
    done
}

main