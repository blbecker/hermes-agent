ARG BASE_IMAGE_TAG=v2026.9.24
FROM nousresearch/hermes-agent:${BASE_IMAGE_TAG}

ARG GITHUB_CLI_VERSION=2.102.0
ARG SOPS_VERSION=3.13.3

# Install kubectl
ARG KUBECTL_VERSION=v1.36
ARG GOOGLE_WORKSPACE_CLI_VERSION=v0.22.5

# Install system dependencies for Rust and GitHub CLI
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    tar \
    gzip \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/Release.key \
        | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/ /" \
        > /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends kubectl \
    && rm -rf /var/lib/apt/lists/* \
    && kubectl version --client

# Install GitHub CLI
RUN curl -L "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz" -o /tmp/gh.tar.gz \
    && tar -xzf /tmp/gh.tar.gz -C /tmp \
    && mv /tmp/gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm -rf /tmp/gh.tar.gz /tmp/gh_${GITHUB_CLI_VERSION}_linux_amd64 \
    && gh --version

# Install Rust toolchain using rustup
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME \
    && rustup --version \
    && cargo --version \
    && rustc --version

# Install sops for secrets management
RUN curl -L https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /tmp/sops \
    && mv /tmp/sops /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops \
    && sops --version

# Install googleworkspace 
RUN curl -L https://github.com/googleworkspace/cli/releases/download/${GOOGLE_WORKSPACE_CLI_VERSION}/google-workspace-cli-x86_64-unknown-linux-gnu.tar.gz -o /tmp/gws.tgz \
    && mkdir -p /tmp/gws \
    && tar xzvf /tmp/gws.tgz -C /tmp/gws \
    && mv /tmp/gws/gws /usr/local/bin/gws \
    && chmod +x /usr/local/bin/gws \
    && gws --version

# Install Agentmail
RUN npm install -g agentmail-cli@latest

# Install Google Workspace dependencies
RUN uv pip install google-auth google-api-python-client

