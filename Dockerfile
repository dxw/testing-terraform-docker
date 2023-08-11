FROM ubuntu:jammy

ARG SHELLCHECK_VERSION="v0.9.0"
ARG RBENV_VERSION="v1.2.0"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    groff \
    libreadline-dev \
    libssl-dev \
    python \
    python-pip \
    python-setuptools \
    unzip \
    wget \
    zlib1g-dev \
    jq \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" | tar -xJf - \
    && cp "shellcheck-${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/shellcheck \
    && rm -rf "shellcheck-${SHELLCHECK_VERSION}"

RUN pip install awscli proselint yamllint

RUN git clone https://github.com/rbenv/rbenv.git --depth 1 --branch "$RBENV_VERSION" ~/.rbenv \
    && ln -s ~/.rbenv/bin/* /usr/local/bin
RUN echo 'export PATH="$PATH:/root/.rbenv/libexec"' >> /root/.bashrc
ENV PATH="$PATH:/root/.rbenv/libexec"

RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"

RUN git clone https://github.com/rbenv/rbenv-default-gems.git "$(rbenv root)/plugins/rbenv-default-gems" \
    && echo "bundler" >> "$(rbenv root)/default-gems" \
    && echo "mdl" >> "$(rbenv root)/default-gems"

RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin

RUN mkdir -p /tmp/tflint \
    && wget https://github.com/wata727/tflint/releases/download/v0.16.2/tflint_linux_amd64.zip -O /tmp/tflint/tflint.zip \
    && unzip /tmp/tflint/tflint.zip -d /tmp/tflint \
    && mv /tmp/tflint/tflint /usr/local/bin/tflint \
    && rm -rf /tmp/tflint

# rewrite url schema for GitHub URLs.
RUN git config --global url."https://github.com/".insteadOf 'git@github.com:'
