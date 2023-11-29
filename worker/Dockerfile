# Copyright 2021 Integritee AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generic Dockerfile for Intel SGX development and CI machines
#  Based on Ubuntu
#  Intel SGX SDK and PSW installed
#  Rust-sgx-sdk installed
#  IPFS installed

FROM ubuntu:22.04

# Install SGX

# Note the manual cleanup step at the end of the command.
# This is not required, but in the case of a base image change it may be.
# See #8 for more details.
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    ocaml \
    automake \
    autoconf \
    libtool \
    wget \
    python3 \
    libssl-dev \
    dkms \
    protobuf-compiler \
    pip \
    python3-click \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

RUN echo 'deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu jammy main' | tee /etc/apt/sources.list.d/intel-sgx.list

RUN wget https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key && cat intel-sgx-deb.key | tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null

RUN apt-get update && apt-get install -y \
    libsgx-uae-service \
    libsgx-epid \
    libsgx-quote-ex \
    libsgx-dcap-ql \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Debug symbols for SGX
RUN apt-get update && apt-get install -y \
    libsgx-urts-dbgsym \
    libsgx-enclave-common-dbgsym \
    libsgx-dcap-ql-dbgsym \
    libsgx-dcap-default-qpl-dbgsym \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# DCAP QPL
RUN apt-get update && apt-get install -y \
    libsgx-dcap-default-qpl \
    libsgx-dcap-quote-verify \
    libsgx-dcap-quote-verify-dev \
    libsgx-dcap-quote-verify-dbgsym \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Install SGX SDK

RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

RUN wget https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu22.04-server/sgx_linux_x64_sdk_2.18.101.1.bin && \
    chmod +x ./sgx_linux_x64_sdk_2.18.101.1.bin && \
    ./sgx_linux_x64_sdk_2.18.101.1.bin --prefix /opt/

RUN apt-get update && apt-get install -y \
    libsgx-enclave-common-dev \
    libsgx-dcap-ql-dev \
    libsgx-dcap-default-qpl-dev \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

SHELL ["/bin/bash", "-c", "source /opt/sgxsdk/environment"]

LABEL maintainer="zoltan@integritee.network"
LABEL description="Generic Dockerfile for Intel SGX development and CI machines"
ARG VERSION_IPFS=0.4.21

RUN echo "VERSION_IPFS = ${VERSION_IPFS}"

SHELL ["/bin/bash", "-c"]

# install rsync
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
    rsync && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install ipfs
RUN mkdir -p /ipfs && \
    cd /ipfs && \
    wget -O go-ipfs.tar.gz https://dist.ipfs.io/go-ipfs/v${VERSION_IPFS}/go-ipfs_v${VERSION_IPFS}_linux-amd64.tar.gz && \
    tar xvfz go-ipfs.tar.gz && \
    cd go-ipfs && \
    ./install.sh

# re-install / downgrade binutils since the baiduxlab/sgx-rust image
# comes with ld version 2.35 which cannot compile the node.
RUN apt-get remove -y binutils && \
    apt-get update && apt-get install -y \
    binutils \
    build-essential \
    debhelper \
    dh-autoreconf \
    dpkg-dev \
    g++ \
    g++-9 \
    gcc \
    gcc-9 \
    libtool \
    ocaml \
    ocaml-compiler-libs \
    ocaml-interp \
    ocaml-nox \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install packages needed for substrate
RUN apt-get update && apt-get install -y \
    cmake \
    pkg-config \
    libssl-dev \
    git \
    gcc \
    build-essential \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install LLVM to compile ring into WASM
RUN apt-get update && apt-get install -y \
    clang-13 \
    lldb-13 \
    lld-13 \
    clangd \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install additional tools
RUN apt-get update && apt-get install -y \
    tmux \
    nano \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install netcat for healthcheck
RUN apt-get update && apt-get install -yq \
    netcat \
    curl \
    gosu \
    && rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*


#
# Adding default user ubuntu
# The user id could be changed during start, see entrypoint.sh
#
ARG UID=1000
ARG GUID=1000
RUN adduser -u ${UID} --disabled-password --gecos '' ubuntu
RUN adduser -u ${UID} ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#
# Install Rust
#
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
RUN chmod 777 /opt/rust -R

# unicode support
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV SGX_SDK /opt/sgxsdk
ENV PATH "$PATH:${SGX_SDK}/bin:${SGX_SDK}/bin/x64:/opt/rust/bin"
ENV PKG_CONFIG_PATH "${PKG_CONFIG_PATH}:${SGX_SDK}/pkgconfig"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${SGX_SDK}/sdk_libs"

COPY entrypoint.sh /entrypoint.sh
COPY .bashrc /home/ubuntu/

WORKDIR /home/ubuntu

ENTRYPOINT ["/entrypoint.sh"]
