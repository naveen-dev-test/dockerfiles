FROM ubuntu:bionic as FVP

ENV DEBIAN_FRONTEND=noninteractive
ENV PKG_DEPS="\
    bc \
    ca-certificates \
    curl \
    libatomic1 \
    libdbus-1-3 \
    openssh-server \
    telnet \
    xterm \
"

RUN set -e ;\
    apt update -q=2 ;\
    apt full-upgrade -q=2 --yes ;\
    apt install -q=2 --yes --no-install-recommends ${PKG_DEPS} ;\
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/*

FROM FVP

WORKDIR /opt/model

COPY setup-sshd /usr/sbin/setup-sshd

# Add the FVP model tarball
# NOTE: some tarballs contain an installer script others don't, so it may be the case
# that the ADD instruction do install the model under /opt/model
ADD Foundation_Platform_11.15_14.tgz .

# Install packages and model
RUN /opt/model/Foundation_Platform.sh \
        --i-agree-to-the-contained-eula \
        --verbose \
        --destination /opt/model/Foundation_Platform && rm -f /opt/model/Foundation_Platform.sh || true

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]
