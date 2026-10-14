ARG BASE_IMAGE_TAG=v2026.9.24
FROM nousresearch/hermes-agent:${BASE_IMAGE_TAG}

# Switch to root for package installation
USER root

# Install system dependencies for Rust
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain using rustup
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME \
    && rustup --version \
    && cargo --version \
    && rustc --version

# Switch back to original hermes user (verified as 'hermes')
USER hermes

# Verify Rust installation as hermes user
RUN cargo --version && rustc --version