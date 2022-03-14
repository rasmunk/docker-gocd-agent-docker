OWNER=ucphhpc
IMAGE=gocd-agent-docker
DEFAULT_TAG=edge
ARGS=

.PHONY: build

all: clean build test

build:
	docker-compose build $(ARGS)

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(DEFAULT_TAG) $(ARGS)

push:
	docker push $(OWNER)/$(IMAGE):$(DEFAULT_TAG) $(ARGS)
