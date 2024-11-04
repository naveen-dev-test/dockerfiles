FROM node:10-alpine

# Can be overriden at build time
ARG BUILDSLAVE_PASSWORD=buildslave

COPY setup-sshd /usr/sbin/setup-sshd

RUN set -e ;\
    # install deps
    apk add bash openjdk11 openssh sudo ;\
    # Setup buildslave user for Jenkins
    adduser buildslave -D -s /bin/bash ;\
    echo "buildslave:$BUILDSLAVE_PASSWORD" | chpasswd ;\
    echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins ;\
    chmod 0440 /etc/sudoers.d/jenkins

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]

