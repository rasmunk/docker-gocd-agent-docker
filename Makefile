OWNER=ucphhpc
IMAGE=gocd-agent-docker
DEFAULT_TAG=edge
ARGS=

.PHONY: build

all: clean init build test

# Link to the original defaults.env if none other is setup
init:
ifeq (,$(wildcard ./.env))
	ln -s defaults.env .env
endif

build:
	docker-compose build $(ARGS)

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(DEFAULT_TAG) $(ARGS)

push:
	docker push $(OWNER)/$(IMAGE):$(DEFAULT_TAG) $(ARGS)
