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
ARG VERSION_UBUNTU=2004
ARG VERSION_RUST_SGX_SDK=1.1.6

FROM niederb/sgx-rust:${VERSION_UBUNTU}-${VERSION_RUST_SGX_SDK}
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

RUN /root/.cargo/bin/rustup self update

# re-install / downgrade binutils since the baiduxlab/sgx-rust image 
# comes with ld version 2.35 which cannot compile the node.
RUN apt-get remove -y binutils && \
    apt-get update && \
    apt-get install -y binutils build-essential clang-10 debhelper dh-autoreconf \
    dpkg-dev g++ g++-9 gcc gcc-8 gcc-9 libtool ocaml \
    ocaml-compiler-libs ocaml-interp ocaml-nox

# install packages needed for substrate
RUN apt-get update && \
    apt-get install -y cmake pkg-config libssl-dev git gcc build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install LLVM to compile ring into WASM
RUN apt-get update && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 10 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install additional tools
RUN apt-get update && \
    apt-get install -y tmux nano && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# install netcat for healthcheck
RUN apt-get update && apt-get install -yq netcat

# set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV SGX_SDK /opt/sgxsdk
ENV PATH "$PATH:${SGX_SDK}/bin:${SGX_SDK}/bin/x64:/root/.cargo/bin"
ENV PKG_CONFIG_PATH "${PKG_CONFIG_PATH}:${SGX_SDK}/pkgconfig"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${SGX_SDK}/sdk_libs"
