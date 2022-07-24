hadolint:
	docker run --rm --interactive \
	--volume $(PWD):/work \
	--workdir=/work \
	hadolint/hadolint hadolint --config ./.hadolint.yml $(shell find ./ -name Dockerfile | sed 's/^./\/work/g' | tr '\n' ' ')

login:
	echo "$(DOCKER_PASSWORD)" | docker login \
	--username $(DOCKER_USERNAME) \
	--password-stdin

my_test:
	ifdef toto
			@echo $(toto)
	else
			@echo 'no toto around'
	endif

build:
	docker build --tag $(DOCKER_USERNAME)/hadoop-base:$(current_branch) ./base