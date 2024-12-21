FROM gocd/gocd-agent-debian-12:v24.5.0
LABEL MAINTAINER="Rasmus Munk <rasmus.munk@nbi.ku.dk>"

USER root

# Docker requirements
# Also install python3 and python3-venv such that packages that leverage
# python as part of their build process can be built
RUN apt update && apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    gosu \
    rsync \
    python3 \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/bin
# Ensure that python base links are present
RUN ln -s python3 python

WORKDIR /

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update && apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install -y \
    make \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*;

ADD pre-docker-entrypoint.sh /pre-docker-entrypoint.sh
RUN chown -R root:root /pre-docker-entrypoint.sh \
    && chmod +x /pre-docker-entrypoint.sh

USER root
# IMPORTANT, since the /pre-docker-entrypoint.sh script is run as root
# Ensure that it launches the /docker-entrypoint.sh script as the go user
# before it exists
ENTRYPOINT ["/pre-docker-entrypoint.sh"]
