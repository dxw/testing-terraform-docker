FROM ubuntu:bionic

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    git \
    python \
    build-essential \
    python-pip \
    python-setuptools \
    wget \
    curl \
    unzip \
    groff \
    shellcheck \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# install rbenv and the version expected by Dalmatian
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && ln -s ~/.rbenv/bin/* /usr/local/bin \
    && rbenv init
RUN rbenv install 2.7.1
RUN rbenv global 2.7.1

# install tfenv and the latest 0.11.4
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin
RUN tfenv install 0.11.14

RUN gem install mdl bundler
RUN pip install awscli proselint yamllint

RUN mkdir -p /tmp/tflint \
    && wget https://github.com/wata727/tflint/releases/download/v0.8.0/tflint_linux_amd64.zip -O /tmp/tflint/tflint.zip \
    && unzip /tmp/tflint/tflint.zip -d /tmp/tflint \
    && mv /tmp/tflint/tflint /usr/local/bin/tflint \
    && rm -rf /tmp/tflint

# rewrite url schema for GitHub URLs.
RUN git config --global url."https://github.com/".insteadOf 'git@github.com:'
