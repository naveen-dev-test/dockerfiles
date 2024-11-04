FROM ubuntu:bionic as FVP

RUN apt-get update && \
    apt-get install --no-install-recommends --yes bc libatomic1 telnet libdbus-1-3 xterm && \
    rm -rf /var/cache/apt

FROM FVP

WORKDIR /opt/model

# Add the FVP model tarball
# NOTE: some tarballs contain an installer script others don't, so it may be the case
# that the ADD instruction do install the model under /opt/model
ADD FVP_Base_RevC-2xAEMv8A_11.12_38.tgz .

# Install packages and model
RUN /opt/model/FVP_Base_RevC-2xAEMv8A.sh \
        --i-agree-to-the-contained-eula \
        --verbose \
        --destination /opt/model/FVP_Base_RevC-2xAEMv8A && rm -f /opt/model/FVP_Base_RevC-2xAEMv8A.sh || true
