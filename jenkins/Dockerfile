FROM jenkins/jenkins:lts-jdk21

ARG TERRAFORM_VERSION=1.17.2

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-venv python3-pip ansible openssh-client curl unzip && \
    curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /tmp/terraform.zip terraform -d /usr/local/bin && \
    rm -rf /tmp/terraform.zip /var/lib/apt/lists/*
USER jenkins
