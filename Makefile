hadolint:

	docker run --rm --interactive \
	--volume $(PWD):/work \
	--workdir=/work \
	hadolint/hadolint hadolint $(shell find ./ -name Dockerfile | sed 's/^./\/work/g' | tr '\n' ' ')

	