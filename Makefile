OWNER=ucphhpc
IMAGE=gocd-agent-docker
BUILD_TAG=edge
ARGS=

.PHONY: build

all: clean build test

build:
	docker-compose build $(ARGS)

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(BUILD_TAG) $(ARGS)

push:
	docker push ${OWNER}/${IMAGE}:${BUILD_TAG} $(ARGS)
