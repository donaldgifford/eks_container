FROM ubuntu:latest


ARG DEBIAN_FRONTEND=noninteractive
ARG HELM_VERSION=v2.9.1
ARG GO_VERSION=go1.10.1


RUN apt-get update -y && \
    apt-get install -y curl wget git vim && \
    #Install kubectl & friends
    curl -sL https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -o /usr/local/bin/kctx && \
    curl -sL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -o  /usr/local/bin/kns && \
    chmod +x /usr/local/bin/k* && \
    # Install helm
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - && \
    mv /linux-amd64/helm /usr/local/bin/helm &&\
    # install golang
    curl -sL https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz | tar zxvf - -C /tmp && \
    # Install heptio authenticator
    GOROOT=/tmp/go GOPATH=/usr/local /tmp/go/bin/go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator && \
    # install helm registry
    mkdir -p ~/.helm/plugins/ && \
    cd ~/.helm/plugins/ && git clone https://github.com/app-registry/appr-helm-plugin.git registry && \
    # clean up
    apt-get remove -y curl git && \
    apt autoremove -y && \
    rm -rf /linux-amd64 /var/lib/apt/lists/* /var/lib/dpkg/info/* /usr/local/src/* /tmp/* && \
    # verify
    helm version --client --short && \
    helm registry --help && \
    kubectl version --client --short


