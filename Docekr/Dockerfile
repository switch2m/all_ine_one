FROM jenkins/jnlp-agent-alpine:latest 
RUN apk update 
RUN apk add git 
RUN apk add ansible 
RUN apk add curl 
# Install yq for changing yaml files 
ADD https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 /usr/local/bin/yq 
RUN chmod +x /usr/local/bin/yq 
RUN yq --version 
# Install Helm 
RUN curl -o /tmp/helm-v3.4.0-linux-amd64.tar.gz https://get.helm.sh/helm-v3.4.0- linux-amd64.tar.gz && \ 
    tar -zxvf /tmp/helm-v3.4.0-linux-amd64.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \ 
    rm -rf /tmp && \ 
    chmod +x /usr/local/bin/helm && \ 
    helm version --client 
USER root
