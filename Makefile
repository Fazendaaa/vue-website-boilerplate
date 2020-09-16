all: setup buildx

setup:
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@docker buildx rm builder
	@docker buildx create --name builder --driver docker-container --use
	@docker buildx inspect --bootstrap

build:
	@docker buildx build --platform \
	linux/386,\
	linux/amd64,\
	linux/arm/v6,\
	linux/arm/v7,\
	linux/arm64/v8,\
	linux/ppc64le,\
	linux/s390x \
	--push --tag ${DOCKER_USER}/vue-website-boilerplate:${PROJECT_TAG} .
