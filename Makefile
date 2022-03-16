OWNER=ucphhpc
IMAGE=gocd-agent-docker
TAG=edge
ARGS=

.PHONY: build

all: clean init build test 

# Link to the original defaults.env if none other is setup
init:
ifeq (,$(wildcard ./.env))
	ln -s defaults.env .env
endif

build:
	docker-compose build --build-arg TAG=$(TAG) $(ARGS)

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(TAG) $(ARGS)

push:
	docker push $(OWNER)/$(IMAGE):$(TAG) $(ARGS)

test:
# TODO, implement tests :)
