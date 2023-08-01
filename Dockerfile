FROM gocd/gocd-agent-debian-11:v23.2.0
LABEL MAINTAINER="Rasmus Munk <rasmus.munk@nbi.ku.dk>"

USER root

# Docker requirements
RUN apt update && apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    gosu \
    python3-pip \
    python3-dev \
    python3-venv \
    rsync \
    && rm -rf /var/lib/apt/lists/*;

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

RUN pip3 install docker-compose

USER root
# IMPORTANT, since the /pre-docker-entrypoint.sh script is run as root
# Ensure that it launches the /docker-entrypoint.sh script as the go user
# before it exists
ENTRYPOINT ["/pre-docker-entrypoint.sh"]
