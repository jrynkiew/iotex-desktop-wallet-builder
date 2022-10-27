FROM ubuntu:20.04 as iotex-explorer
LABEL maintainer="Jeremi Rynkiewicz JRPC <jeremi@jrpc.pl>"
LABEL name="nvm-dev-env"
LABEL version="latest"

RUN apk update \
    && apk upgrade \
    && apk add \
       doas \ 
       git \
       python2 \
       bash \
       bash-completion \
       make \
       gcc \
       g++ \
       libc-dev \
       eudev-dev \
       libusb-dev \
       linux-headers \
       vim \
       curl \
       gcompat \
       libstdc++

RUN git clone -b main --single-branch https://github.com/jrynkiew/iotex-desktop-wallet.git $HOME/app

SHELL ["bash", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash \
    && echo 'export NVM_DIR="$HOME/.nvm"' > $HOME/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"' >> $HOME/.bashrc \
    && chmod +x $HOME/.nvm/nvm.sh \
    && . $HOME/.bashrc \
    && nvm install v14.20.1

WORKDIR $HOME/app
    
RUN npm install

# RUN rm -r node_modules/ || true \
#     && rm package-lock.json || true \
#     && rm yarn.lock || true 

# RUN npm install \
#     && npm run postinstall \
#     && npm run build \
#     && npm run build-production

# FROM node:14.20.0-alpine3.15 as iotex-desktop-wallet

# RUN apk update \
#     && apk upgrade \
#     && apk add \ 
#       git \
#       python2 \
#       bash \
#       make \
#       gcc \
#       libc-dev \
#       linux-headers \
#       eudev-dev \
#       libusb-dev \
#       g++ \
#       vim

# COPY --from=iotex-explorer /app/iotex-desktop-wallet /app/iotex-desktop-wallet

# WORKDIR /app/iotex-desktop-wallet/src/electron

# RUN rm -r node_modules/ || true \
#     && rm package-lock.json || true \
#     && rm yarn.lock || true 

# RUN npm install --save babel-loader

# RUN npm install