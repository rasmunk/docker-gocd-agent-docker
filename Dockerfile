FROM gocd/gocd-agent-debian-10:v21.3.0

LABEL MAINTAINER="Rasmus Munk <rasmus.munk@nbi.ku.dk>"

USER root

# Docker requirements
RUN apt update && apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update && apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

RUN apt install -y \
    make

ADD pre-docker-entrypoint.sh /pre-docker-entrypoint.sh
RUN chown -R root:root /pre-docker-entrypoint.sh \
    && chmod +x /pre-docker-entrypoint.sh

# IMPORTANT, since the /pre-docker-entrypoint.sh script is run as root
# Ensure that it launches the /docker-entrypoint.sh script as the go user
# before it exists
ENTRYPOINT ["/pre-docker-entrypoint.sh"]