
define render
    sed -r "s|\{\{\s*java_version\s*\}\}|${1}|" ${2}
endef

versions = 8 11 17

generate_dockerfiles:
	mkdir -p dockerfiles
	for version in $(versions); do \
		echo $$version; \
		mkdir -p dockerfiles/openjdk$${version}; \
        cp -r ./assets ./dockerfiles/openjdk$${version}; \
		$(call render,$${version},Dockerfile.template) > ./dockerfiles/openjdk$${version}/Dockerfile
	done


hadolint:
	docker run --rm --interactive \
	--volume ${PWD}:/work \
	--workdir=/work \
	hadolint/hadolint hadolint --config ./.hadolint.yml $(shell find ./ -name Dockerfile | sed 's/^./\/work/g' | tr '\n' ' ')

login:
	echo "${DOCKER_PASSWORD}" | docker login \
	--username ${DOCKER_USERNAME} \
	--password-stdin

build:
	for openjdk in $(shell ls ./dockerfiles); do \
		(docker build --tag ${DOCKER_USERNAME}/$${openjdk}:0.1 ./dockerfiles/$${openjdk} &) ; \
	done
	wait

push:
	for openjdk in $(shell ls ./dockerfiles); do \
		(docker push ${DOCKER_USERNAME}/$${openjdk}:0.1 &) ; \
	done
	wait