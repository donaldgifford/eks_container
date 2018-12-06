FROM ubuntu:latest


ARG DEBIAN_FRONTEND=noninteractive
ARG HELM_VERSION=v2.9.1
ARG HELM_DIFF_VERSION=v2.9.0+3
ARG HELMFILE_VERSION=v0.35.0
ARG GO_VERSION=go1.10.1
ARG GOROOT=/tmp/go 
ARG GOPATH=/usr/local


RUN apt-get update -y && \
    apt-get install -y curl wget git vim

    #Install kubectl & friends
RUN    curl -sL https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -o /usr/local/bin/kctx && \
    curl -sL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -o  /usr/local/bin/kns && \
    curl -sL https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 -o  /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/k* && \
    chmod +x /usr/local/bin/helmfile &&\
    # Install helm
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - && \
    mv /linux-amd64/helm /usr/local/bin/helm &&\
    # install golang
    curl -sL https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz | tar zxvf - -C /tmp && \
    # Install heptio authenticator
     /tmp/go/bin/go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator && \
    # install helm registry
    mkdir -p ~/.helm/plugins/ && \
    cd ~/.helm/plugins/ && git clone https://github.com/app-registry/appr-helm-plugin.git registry

    # Install helm diff
RUN    helm plugin install https://github.com/databus23/helm-diff --version $HELM_DIFF_VERSION &&\
    # clean up
    apt-get remove -y curl git && \
    apt autoremove -y && \
    rm -rf /linux-amd64 /var/lib/apt/lists/* /var/lib/dpkg/info/* /usr/local/src/* /tmp/* && \
    # verify
    helm version --client --short && \
    helm registry --help && \
    helmfile --version && \
    kubectl version --client --short


