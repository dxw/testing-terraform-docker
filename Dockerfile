FROM ubuntu:bionic

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    git \
    python \
    ruby \
    ruby-dev \
    build-essential \
    python-pip \
    python-setuptools \
    wget \
    unzip \
    groff \
    shellcheck \
    yamllint \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN gem install mdl bundler

RUN pip install awscli proselint

RUN mkdir -p /tmp/tflint \
    && mkdir -p /tmp/terraform \
    && wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip -O /tmp/terraform/terraform.zip\
    && wget https://github.com/wata727/tflint/releases/download/v0.6.0/tflint_linux_amd64.zip -O /tmp/tflint/tflint.zip\
    && unzip /tmp/terraform/terraform.zip -d /tmp/terraform\
    && unzip /tmp/tflint/tflint.zip -d /tmp/tflint\
    && mv /tmp/terraform/terraform /usr/local/bin/terraform\
    && mv /tmp/tflint/tflint /usr/local/bin/tflint\
    && rm -rf /tmp/terraform /tmp/tflint

# rewrite url schema for GitHub URLs.
RUN git config --global url."https://github.com/".insteadOf 'git@github.com:'
