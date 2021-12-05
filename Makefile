OWNER=ucphhpc
IMAGE=gocd-agent-docker
TAG=edge
ARGS=

.PHONY: build

all: clean build test

build:
	docker build -t $(OWNER)/$(IMAGE):$(TAG) $(ARGS) .

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(TAG) $(ARGS)

push:
	docker push ${OWNER}/${IMAGE}:${TAG} $(ARGS)
