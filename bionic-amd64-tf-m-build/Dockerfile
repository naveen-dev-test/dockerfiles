FROM ubuntu:bionic

# Environment variables used by CI scripts
ENV ARMLMD_LICENSE_FILE=27000@flexnet.trustedfirmware.org
ENV DOCKER_PREFIX=987685672616.dkr.ecr.us-east-1.amazonaws.com
ENV LICENSE_VARIABLE=ARMLMD_LICENSE_FILE=27000@flexnet.trustedfirmware.org

ENV DEBIAN_FRONTEND=noninteractive
ENV TOOLS_DIR=/home/buildslave/tools
ENV PATH=${TOOLS_DIR}/bin:${PATH}
ENV PLANTUML_JAR_PATH=/usr/share/plantuml/plantuml.jar
ENV COMPILER_DIR=/home/buildslave/compiler
ENV GCC_7_3_1_DIR=${COMPILER_DIR}/gcc-7-3-1
ENV GCC_7_3_1_PATH=${GCC_7_3_1_DIR}/bin
ENV GCC_10_3_DIR=${COMPILER_DIR}/gcc-10-3
ENV GCC_10_3_PATH=${GCC_10_3_DIR}/bin
ENV GCC_11_2_DIR=${COMPILER_DIR}/gcc-11-2
ENV GCC_11_2_PATH=${GCC_11_2_DIR}/bin
ENV ARMCLANG_6_20_DIR=${COMPILER_DIR}/armclang-6-20
ENV ARMCLANG_6_20_PATH=${ARMCLANG_6_20_DIR}/bin
ENV ARMCLANG_6_21_DIR=${COMPILER_DIR}/armclang-6-21
ENV ARMCLANG_6_21_PATH=${ARMCLANG_6_21_DIR}/bin
ENV PKG_DEPS="\
    bison \
    build-essential \
    clang-tools-6.0 \
    curl \
    default-jre \
    device-tree-compiler \
    doxygen \
    exuberant-ctags \
    flex \
    g++-multilib \
    gcc-multilib \
    gdisk \
    git \
    graphviz \
    jq \
    lcov \
    libffi-dev \
    librsvg2-bin \
    libssl-dev \
    libxml-libxml-perl \
    locales \
    ninja-build \
    openjdk-11-jre-headless \
    openssh-server \
    perl \
    python \
    python-psutil \
    python3 \
    python3-crypto \
    python3-dev \
    python3-pyasn1 \
    srecord \
    sudo \
    tree \
    unzip \
    uuid-runtime \
    virtualenv \
    wget \
    zip \
"

# Can be overriden at build time
ARG BUILDSLAVE_PASSWORD=buildslave

COPY requirements_*.txt /opt/
COPY tf-*.install /tmp/
COPY setup-sshd /usr/sbin/setup-sshd

# Copy armclang toolchains
COPY ARMCompiler*.tar.gz /tmp/

RUN set -ex ;\
    echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections ;\
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections ;\
    apt update -q=2 ;\
    apt dist-upgrade -q=2 --yes ;\
    apt install -q=2 --yes --no-install-recommends ${PKG_DEPS} ;\
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash ;\
    apt update -q=2 ;\
    apt install -q=2 --yes --no-install-recommends git-lfs ;\
    # Install Python requirements
    curl -s https://bootstrap.pypa.io/pip/3.5/get-pip.py -o /tmp/get-pip.py ;\
    python2 /tmp/get-pip.py ;\
    pip2 install --no-cache-dir -r /opt/requirements_python2.txt ;\
    python3 /tmp/get-pip.py ;\
    pip3 install --no-cache-dir -r /opt/requirements_python3.txt ;\
    # Set Python 3 as default
    ln -s -f /usr/bin/python3 /usr/bin/python ;\
    # Setup buildslave user for Jenkins
    useradd -m -s /bin/bash buildslave ;\
    echo "buildslave:$BUILDSLAVE_PASSWORD" | chpasswd ;\
    echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins ;\
    chmod 0440 /etc/sudoers.d/jenkins ;\
    mkdir -p /var/run/sshd ${TOOLS_DIR} ${COMPILER_DIR};\
    # Run shell script(s) to install files, toolchains, etc...
    bash -ex /tmp/tf-dependencies.install ;\
    bash -ex /tmp/tf-environment.install ;\
    # Fix permissions
    chown -R buildslave:buildslave ${TOOLS_DIR} ${COMPILER_DIR} /usr/share/plantuml ;\
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER buildslave

RUN set -e ;\
    # Set git default config
    git config --global user.email "ci@trustedfirmware.org" ;\
    git config --global user.name "TF CI" ;\
    git config --global color.ui "auto"

USER root

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]

