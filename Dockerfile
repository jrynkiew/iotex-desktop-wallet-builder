# # escape=\

# FROM alpine:3.15 as nvm-builder
# LABEL maintainer="Jeremi Rynkiewicz JRPC <jeremi@jrpc.pl>"
# LABEL name="nvm-builder-alpine"
# LABEL version="0.1.0"

# # Declare constants
# ENV NVM_VERSION v0.39.2
# ENV NODE_VERSION v10.24.1

# # Install pre-reqs
# RUN apk update \
#     && apk upgrade \
#     && apk add \
#        doas \ 
#        git \
#        python2 \
#        bash \
#        bash-completion \
#        make \
#        gcc \
#        g++ \
#        libc-dev \
#        eudev-dev \
#        libusb-dev \
#        linux-headers \
#        vim \
#        curl

# # Replace shell with bash so we can source files
# RUN rm /bin/ash && ln -s /bin/bash /bin/ash

# SHELL ["bash", "-c"]

# # Install NVM
# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# # Install NODE
# RUN source ~/.nvm/nvm.sh; \
#     nvm install $NODE_VERSION; \
#     nvm use --delete-prefix $NODE_VERSION;

# RUN git clone -b main --single-branch https://github.com/jrynkiew/iotex-desktop-wallet.git /usr/apps/iotex-desktop-wallet

# escape=\

FROM ubuntu:20.04 as nvm-builder
LABEL maintainer="Jeremi Rynkiewicz JRPC <jeremi@jrpc.pl>"
LABEL name="nvm-builder-ubuntu"
LABEL version="0.1.0"

# Declare constants
ENV NVM_DIR         /usr/local/nvm
ENV NVM_VERSION     v0.39.2
ENV NODE_VERSION    v10.24.1
ENV NODE_PATH       $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH            $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install pre-reqs
RUN apt-get update
RUN apt-get -y install curl build-essential git vim python3 python libusb-1.0-0-dev

# Pre-create NVM dir
RUN mkdir /usr/local/nvm

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
RUN source $NVM_DIR/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use --delete-prefix $NODE_VERSION;

# Enter into working directory
WORKDIR /usr/app

# Download app sources
RUN git clone -b master --single-branch https://github.com/jrynkiew/iotex-desktop-wallet.git /usr/app; \
    npm install; \
    npm run build; \
    cd /usr/app/src/electron; \
    npm install;
    
# Build application
WORKDIR /usr/app/src/electron
