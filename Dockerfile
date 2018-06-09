FROM ubuntu:latest

ENV TZ=Utc \
    GOROOT=/usr/local/go \
    GOPATH=$HOME/go

ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y curl python-pip git && \
    pip install awscli && \
    pip list --format columns


#Install kubectl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# install golang
RUN curl -sL https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz | tar zxvf - -C /usr/local/


# Install helm
RUN curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz | tar zxvf -
RUN mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64/

#Install heptio authenticator
RUN go get -u -v github.com/heptio/authenticator/cmd/heptio-authenticator-aws

CMD ["bash"]
