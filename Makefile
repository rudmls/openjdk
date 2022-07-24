define task
	sleep 0.5; echo "$1";
endef

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
		docker build --tag ${DOCKER_USERNAME}/$${openjdk}:0.1 ./dockerfiles/$${openjdk} & ; \
	done; \
	wait

push:
	for openjdk in $(shell ls ./dockerfiles); do \
		(docker push ${DOCKER_USERNAME}/$${openjdk}:0.1 &) ; \
	done; \
	wait

test:
	for number in 1 2 3 4 ; do \
		(echo "$${number}" &) ; \
    done
