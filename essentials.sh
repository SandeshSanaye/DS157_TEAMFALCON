#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------------
# Update the entire system to the latest versions
# ----------------------------------------------------------------
apt-get clean && apt-get -qq update && apt-get upgrade -y

# ----------------------------------------------------------------
# Install some basic utilities
# ----------------------------------------------------------------
apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    g++ \
    git \
    jq \
    libtool \
    make \
    unzip