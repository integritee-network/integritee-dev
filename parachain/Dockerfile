# Note: We don't use Alpine and its packaged Rust/Cargo because they're too often out of date,
# preventing them from being used to build Substrate/Polkadot.
# Copy from: https://github.com/paritytech/substrate/blob/master/.maintain/Dockerfile

FROM phusion/baseimage:0.11 as builder
LABEL maintainer="zoltan@integritee.network"
LABEL description="This is the template Dockerfile for Integritee Parachain."

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get dist-upgrade -y -o Dpkg::Options::="--force-confold" && \
	apt-get install -y cmake pkg-config libssl-dev git clang

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH="$PATH:$HOME/.cargo/bin" && \
	rustup toolchain install nightly && \
	rustup target add wasm32-unknown-unknown --toolchain nightly && \
	rustup default stable 

RUN echo "PATH=\"$PATH:/root/.cargo/bin\"" >> /etc/environment
