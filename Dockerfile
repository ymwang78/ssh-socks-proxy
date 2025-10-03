FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y autossh sshpass openssh-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
