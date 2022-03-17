OWNER=ucphhpc
IMAGE=gocd-agent-docker
TAG=edge
# Enable that the builder should use buildkit
# https://docs.docker.com/develop/develop-images/build_enhancements/
DOCKER_BUILDKIT=1

.PHONY: all init build push

all: clean init build test 

# Link to the original defaults.env if none other is setup
init:
ifeq (,$(wildcard ./.env))
	ln -s defaults.env .env
endif

build:
	docker-compose build $(ARGS)

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(TAG) $(ARGS)

push:
	docker push $(OWNER)/$(IMAGE):$(TAG) $(ARGS)

test:
# TODO, implement tests :)
