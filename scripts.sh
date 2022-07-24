
function render() {
    sed -r "s|\{\{\s*java_version\s*\}\}|${1}|" ${2}
}

function generate_dockerfiles() {
    versions=(8 11 17)
    mkdir -p dockerfiles
    for version in ${versions[*]}; do
        mkdir -p dockerfiles/openjdk${version} && \
        cp -r ./assets ./dockerfiles/openjdk${version} && \
        render "${version}" "Dockerfile.template" > ./dockerfiles/openjdk${version}/Dockerfile || exit 1
    done
}

function hadolint() {
	docker run --rm --interactive \
	--volume ${PWD}:/work \
	--workdir=/work \
	hadolint/hadolint hadolint --config ./.hadolint.yml $(find ./ -name Dockerfile | sed 's/^./\/work/g' | tr '\n' ' ')
}

function docker_login() {
	echo "${DOCKER_PASSWORD}" | docker login \
	--username ${DOCKER_USERNAME} \
	--password-stdin
}

function docker_build() {
    for openjdk in $(ls ./dockerfiles); do
        docker build --tag ${DOCKER_USERNAME}/${openjdk}:0.1 ./dockerfiles/${openjdk} &
    done
    wait
}

function docker_push() {
    for openjdk in $(ls ./dockerfiles); do
        docker push ${DOCKER_USERNAME}/${openjdk}:0.1 &
    done
    wait
}

function main() {
    action=$1
    case ${action} in
        "generate_dockerfiles") generate_dockerfiles ;;
        "hadolint") hadolint ;;
        "docker_login") docker_login ;;
        "docker_build") docker_build ;;
        "docker_push") docker_push ;;
    esac
}

main $@