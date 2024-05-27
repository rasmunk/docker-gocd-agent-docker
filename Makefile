PACKAGE_NAME=gocd-agent-docker
PACKAGE_NAME_FORMATTED=$(subst -,_,$(PACKAGE_NAME))
OWNER=ucphhpc
IMAGE=$(PACKAGE_NAME)
# Enable that the builder should use buildkit
# https://docs.docker.com/develop/develop-images/build_enhancements/
DOCKER_BUILDKIT=1
# NOTE: dynamic lookup with docker as default and fallback to podman
DOCKER=$(shell which docker || which podman)
# if docker compose plugin is not available, try old docker-compose/podman-compose
ifeq (, $(shell ${DOCKER} help|grep compose))
	DOCKER_COMPOSE=$(shell which docker-compose || which podman-compose)
else
	DOCKER_COMPOSE=docker compose
endif
$(echo ${DOCKER_COMPOSE} >/dev/null)
TAG=edge
ARGS=

.PHONY: all init dockerbuild dockerclean dockerpush clean dist distclean maintainer-clean
.PHONY: install uninstall installtest test

all: init dockerbuild

init:
ifeq ($(shell test -e defaults.env && echo yes), yes)
ifneq ($(shell test -e .env && echo yes), yes)
		ln -s defaults.env .env
endif
endif

dockerbuild:
	${DOCKER_COMPOSE} build ${ARGS}

dockerclean:
	${DOCKER} rmi -f ${OWNER}/${IMAGE}:${TAG}

dockerpush:
	${DOCKER} push ${OWNER}/${IMAGE}:${TAG}

clean:
	${MAKE} dockerclean
	${MAKE} distclean
	rm -fr .env
	rm -fr .pytest_cache
	rm -fr tests/__pycache__

dist:
### PLACEHOLDER ###

distclean:
### PLACEHOLDER ###

maintainer-clean:
	@echo 'This command is intended for maintainers to use; it'
	@echo 'deletes files that may need special tools to rebuild.'
	${MAKE} distclean

install-dep:
### PLACEHOLDER ###

install:
	${MAKE} install-dep

uninstall:
### PLACEHOLDER ###

uninstalltest:
### PLACEHOLDER ###

installtest:
### PLACEHOLDER ###

test:
### PLACEHOLDER ###
